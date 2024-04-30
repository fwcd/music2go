import ArgumentParser
import Foundation
import MusicLibrary

@main
struct Music2Go: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "music2go")

    @Option(name: .shortAndLong, help: "The path to the output folder.")
    var output: String

    func run() throws {
        let outputURL = URL(filePath: output)
        try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true)

        let importer = try LocalAppleMediaImporter()
        var library = try importer.readLibrary(onProgress: handle(progress:))
        print()

        let musicURL = outputURL.appending(components: "Music")
        try FileManager.default.createDirectory(at: musicURL, withIntermediateDirectories: true)

        let copier = CopyProcessor { track -> URL? in
            guard let url = track.url else { return nil }
            let artist = track.artist?.nilIfEmpty?.trimmingCharacters(in: .alphanumerics.inverted).prefix(32)
            let title = track.title?.nilIfEmpty?.trimmingCharacters(in: .alphanumerics.inverted).prefix(32)
            let dirName = artist?.first.map(String.init) ?? "Unknown"
            let fileName = "\([artist, title].compactMap { $0 }.joined(separator: " - ")).\(url.pathExtension)"
            return musicURL.appending(components: dirName, fileName)
        }
        try copier.process(library: &library, onProgress: handle(progress:))
        print()

        let xmlURL = outputURL.appending(component: "Library.xml")
        let exporter = LibraryXMLExporter(url: xmlURL)
        try exporter.write(library: library, onProgress: handle(progress:))
        print()
    }

    private func handle(progress: ProgressInfo) {
        print("\u{1b}[2K\r[\(progress.current + 1)\(progress.total.map { "/\($0)" } ?? "")] \(progress.message ?? "")", terminator: "")
        fflush(stdout)
    }
}
