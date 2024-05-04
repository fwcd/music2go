import MusicLibrary

// TODO: Make this more generic, i.e. parse other key formats too

/// Remaps (traditional) keys stored in a track field.
struct KeyRemappingProcessor: LibraryProcessor {
    let keyField: WritableKeyPath<Track, String?>
    let formatter: (Key) -> String

    func process(library: inout Library, onProgress: (ProgressInfo) -> Void) throws {
        var progress = ProgressInfo(total: library.tracks.count) {
            didSet { onProgress(progress) }
        }

        var newTracks: [Int: Track] = [:]
        for (i, (id, track)) in library.tracks.enumerated() {
            var track = track
            if let oldKey = track[keyPath: keyField], let key = Key(rawValue: oldKey) {
                let newKey = formatter(key)
                progress.update(current: i, message: "Remapping key \(oldKey) -> \(newKey)...")
                track[keyPath: keyField] = newKey
            }
            newTracks[id] = track
        }

        library.tracks = newTracks
    }
}
