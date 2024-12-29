import Testing
import MusicLibrary
@testable import Music2GoSupport

struct TrackPlaylistFilterProcessorTests {
    @Test func playlistTree() {
        let library = makeDemoLibrary()

        let tree = TrackPlaylistFilterProcessor.PlaylistNode(library: library)
        #expect(tree == TrackPlaylistFilterProcessor.PlaylistNode(
            name: "",
            children: [
                .init(name: "A", children: [
                    .init(name: "B", tracks: [0, 2, 4].map { TrackReference(trackId: $0) }),
                    .init(name: "C", children: [
                        .init(name: "D", tracks: [1, 2, 3].map { TrackReference(trackId: $0) }),
                    ]),
                ], tracks: [TrackReference(trackId: 0)]),
                .init(name: "E"),
            ]
        ))

        #expect(tree.trackPlaylistPaths(separator: "/") == [
            0: ["A", "A/B"],
            1: ["A/C/D"],
            2: ["A/B", "A/C/D"],
            3: ["A/C/D"],
            4: ["A/B"],
        ])
    }

    private func makeDemoLibrary() -> Library {
        Library(
            tracks: Dictionary(uniqueKeysWithValues: (0..<10).map { ($0, Track(id: $0)) }),
            playlists: [
                Playlist(id: 1, name: "A", persistentId: "1", items: [TrackReference(trackId: 0)]),
                Playlist(id: 2, name: "B", persistentId: "2", parentPersistentId: "1", items: [0, 2, 4].map { TrackReference(trackId: $0) }),
                Playlist(id: 3, name: "C", persistentId: "3", parentPersistentId: "1"),
                Playlist(id: 4, name: "D", persistentId: "4", parentPersistentId: "3", items: [1, 2, 3].map { TrackReference(trackId: $0) }),
                Playlist(id: 5, name: "E", persistentId: "5"),
            ]
        )
    }
}
