import ArgumentParser
import Foundation
import MusicLibrary

@main
struct Music2Go: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "music2go")

    @Option(name: .shortAndLong, help: "The path to the output folder.")
    var output: String

    @Option(name: .shortAndLong, help: "The name of the library file to generate. Determines the output format.")
    var file: String = "Library.xml"

    @Flag(name: .long, inversion: .prefixedNo, help: "Copy media files to the output folder.")
    var copy: Bool = true

    func run() throws {
        let outputURL = URL(filePath: output)
        try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true)

        let importer = try LocalAppleMediaImporter()
        var library = try importer.readLibrary(onProgress: handle(progress:))
        print()

        if copy {
            let mediaURL = outputURL.appending(components: "Media")
            try FileManager.default.createDirectory(at: mediaURL, withIntermediateDirectories: true)
            library.mediaFolderLocation = mediaURL.absoluteString

            let copier = CopyProcessor { track -> URL? in
                guard let url = track.url else { return nil }
                let artist = track.artist.map(sanitize)?.nilIfEmpty
                let title = track.title.map(sanitize)?.nilIfEmpty
                let dirName = artist?.first.map(String.init) ?? "Unknown"
                let fileName = "\([artist, title].compactMap { $0 }.joined(separator: " - ")).\(url.pathExtension)"
                return mediaURL.appending(components: dirName, fileName)
            }
            try copier.process(library: &library, onProgress: handle(progress:))
            print()
        }

        let fileURL = outputURL.appending(component: file)

        let exporter: any LibraryExporter
        switch file.split(separator: ".").last! {
        case "xml": exporter = LibraryXMLExporter(url: fileURL)
        case "json": exporter = LibraryJSONExporter(url: fileURL)
        case let fileExt: fatalError("Unrecognized output file extension: \(fileExt)")
        }

        try exporter.write(library: library, onProgress: handle(progress:))
        print()
    }

    private func handle(progress: ProgressInfo) {
        print("\u{1b}[2K\r[\(progress.current + 1)\(progress.total.map { "/\($0)" } ?? "")] \(progress.message ?? "")", terminator: "")
        fflush(stdout)
    }

    private func sanitize(_ s: String) -> String {
        String(s
            .replacing("ä", with: "ae")
            .replacing("ö", with: "oe")
            .replacing("ü", with: "ue")
            .replacing("Ä", with: "Ae")
            .replacing("Ö", with: "Oe")
            .replacing("Ü", with: "Ue")
            .replacing("ß", with: "ss")
            .replacing(#/\s+/#, with: " ")
            .replacing(#/[^a-zA-Z0-9\.\-&() ]/#, with: "_")
            .prefix(32)
        )
    }
}
