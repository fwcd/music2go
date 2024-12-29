import Foundation

/// Metadata about an exported library that is conventionally stored in `Music2Go.json`.
public struct Metadata: Codable, Hashable, Sendable {
    /// The version of the Music2Go export format. Should be incremented
    /// whenever the schema of this type or the folder layout changes.
    public var version: Int
    // TODO: Use a property wrapper (e.g. @CustomCodable) and express this as a Date directly.
    /// The ISO8601 date/time of the export.
    public var exportedAt: String
    /// The SHA256 checksum of the `Library.xml` or `Library.json` as a basic
    /// integrity check.
    public var libraryFileSha256: String
    /// Some statistics for reference.
    public var statistics: Statistics

    public init(
        version: Int = 1,
        exportedAt: String = ISO8601DateFormatter().string(from: Date()),
        libraryFileSha256: String,
        statistics: Statistics
    ) {
        self.version = version
        self.exportedAt = exportedAt
        self.libraryFileSha256 = libraryFileSha256
        self.statistics = statistics
    }

    public struct Statistics: Codable, Hashable, Sendable {
        /// The number of tracks.
        public let trackCount: Int
        /// The number of playlists.
        public let playlistCount: Int

        public init(trackCount: Int, playlistCount: Int) {
            self.trackCount = trackCount
            self.playlistCount = playlistCount
        }
    }
}
