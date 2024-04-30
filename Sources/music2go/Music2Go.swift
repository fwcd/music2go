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
        let library = try importer.readLibrary()

        let xmlURL = outputURL.appending(component: "Library.xml")
        let exporter = LibraryXMLExporter(url: xmlURL)
        try exporter.write(library: library)
    }
}
