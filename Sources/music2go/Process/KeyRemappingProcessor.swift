import MusicLibrary

// TODO: Make this more generic, i.e. parse other key formats too

/// Remaps (traditional) keys stored in a track field.
struct KeyRemappingProcessor: LibraryProcessor {
    let keyField: WritableKeyPath<Track, String?>
    let formatter: (Key) -> String

    func process(library: inout Library, onProgress: (ProgressInfo) -> Void) throws {
        library.tracks = library.tracks.mapValues { track in
            var track = track
            if let key = track[keyPath: keyField].flatMap(Key.init(rawValue:)) {
                track[keyPath: keyField] = formatter(key)
            }
            return track
        }
    }
}
