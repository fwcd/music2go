import Foundation

/// Metadata about an exported library that is conventionally stored in `Music2Go.json`.
struct Metadata: Codable, Hashable, Sendable {
    /// The version of the Music2Go export format. Should be incremented
    /// whenever the schema of this type or the folder layout changes.
    var version: Int = 1
    // TODO: Use a property wrapper (e.g. @CustomCodable) and express this as a Date directly.
    /// The ISO8601 date/time of the export.
    var exportedAt: String = ISO8601DateFormatter().string(from: Date())
    /// The SHA256 checksum of the `Library.xml` or `Library.json` as a basic
    /// integrity check.
    var libraryFileSha256: String
    /// Some statistics for reference.
    var statistics: Statistics

    struct Statistics: Codable, Hashable, Sendable {
        /// The number of tracks.
        let trackCount: Int
        /// The number of playlists.
        let playlistCount: Int
    }
}
