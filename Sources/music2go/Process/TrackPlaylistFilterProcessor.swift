import MusicLibrary

/// Handles inclusions and exclusions based on playlist paths.
struct TrackPlaylistFilterProcessor: LibraryProcessor {
    let playlistPaths: Set<String>
    let mode: Mode
    var separator: String = "/"

    enum Mode: Hashable {
        case include
        case exclude
    }

    func process(library: inout Library, onProgress: (ProgressInfo) -> Void) throws {
        var progress = ProgressInfo(total: library.tracks.count) {
            didSet { onProgress(progress) }
        }

        let playlistTree = PlaylistNode(library: library)
        let trackPlaylistPaths = playlistTree.trackPlaylistPaths(separator: separator)

        var newTracks: [Int: Track] = [:]
        for (i, (id, track)) in library.tracks.enumerated() {
            let memberships = trackPlaylistPaths[id] ?? []
            let isMemberOfFilter = !memberships.isDisjoint(with: playlistPaths)
            let shouldInclude = switch mode {
            case .include: isMemberOfFilter
            case .exclude: !isMemberOfFilter
            }
            if shouldInclude {
                newTracks[id] = track
            }
            progress.update(current: i, message: "\(shouldInclude ? "Including" : "Excluding") \(track.title ?? "")")
        }

        library.tracks = newTracks
    }

    private struct PlaylistNode {
        let name: String
        let children: [PlaylistNode]
        let tracks: [TrackReference]

        init(library: Library, persistentId: String? = nil) {
            let playlist = library.playlists.first { $0.persistentId == persistentId }
            let childPlaylists = library.playlists.filter { $0.parentPersistentId == persistentId }

            name = playlist?.name ?? ""
            children = childPlaylists.map { .init(library: library, persistentId: $0.persistentId) }
            tracks = playlist?.items ?? []
        }

        func trackPlaylistPaths(separator: String, prefix: [String] = []) -> [Int: Set<String>] {
            let path = prefix + [name]
            let joinedPath = path.joined(separator: separator)
            return children.reduce(into: [Int: Set<String>](uniqueKeysWithValues: Set(tracks.map(\.trackId)).map { ($0, [joinedPath]) })) { acc, child in
                acc.merge(child.trackPlaylistPaths(separator: separator, prefix: path)) {
                    $0.union($1)
                }
            }
        }
    }
}
