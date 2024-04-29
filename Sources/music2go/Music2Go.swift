import ArgumentParser

@main
struct Music2Go: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "music2go")

    func run() {
        print("Hello, world!")
    }
}
