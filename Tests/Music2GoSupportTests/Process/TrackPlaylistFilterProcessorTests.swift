import Testing
import MusicLibrary
@testable import Music2GoSupport

struct TrackPlaylistFilterProcessorTests {
    @Test func playlistTree() {
        let library = makeDemoLibrary()

        #expect(TrackPlaylistFilterProcessor.PlaylistNode(library: library) == .init(
            name: "",
            children: [
                .init(name: "A", children: [
                    .init(name: "B"),
                    .init(name: "C", children: [
                        .init(name: "D"),
                    ]),
                ]),
                .init(name: "E"),
            ]
        ))
    }

    private func makeDemoLibrary() -> Library {
        Library(
            tracks: Dictionary(uniqueKeysWithValues: (0..<10).map { ($0, Track(id: $0)) }),
            playlists: [
                Playlist(id: 1, name: "A", persistentId: "1"),
                Playlist(id: 2, name: "B", persistentId: "2", parentPersistentId: "1"),
                Playlist(id: 3, name: "C", persistentId: "3", parentPersistentId: "1"),
                Playlist(id: 4, name: "D", persistentId: "4", parentPersistentId: "3"),
                Playlist(id: 5, name: "E", persistentId: "5"),
            ]
        )
    }
}
