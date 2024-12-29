import MusicLibrary
import Foundation

extension Metadata {
    public init(library: Library, exportedFileURL: URL) throws {
        let libraryFileSha256 = String(try runSubprocess(["sha256sum", exportedFileURL.path]).split(separator: " ").first!)

        self.init(
            libraryFileSha256: libraryFileSha256,
            statistics: .init(
                trackCount: library.tracks.count,
                playlistCount: library.playlists.count
            )
        )
    }
}
