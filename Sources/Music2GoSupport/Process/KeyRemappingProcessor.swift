import MusicLibrary

// TODO: Make this more generic, i.e. parse other key formats too

/// Remaps (traditional) keys stored in a track field.
public struct KeyRemappingProcessor: LibraryProcessor {
    private let keyField: WritableKeyPath<Track, String?>
    private let formatter: (Key) -> String

    public init(keyField: WritableKeyPath<Track, String?>, formatter: @escaping (Key) -> String) {
        self.keyField = keyField
        self.formatter = formatter
    }

    public func process(library: inout Library, onProgress: (ProgressInfo) -> Void) throws {
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
