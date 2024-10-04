import Foundation

func runSubprocess(_ command: [String]) throws -> String {
    let process = Process()
    let pipe = Pipe()

    process.standardOutput = pipe
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = command

    try process.run()

    let data = try pipe.fileHandleForReading.readToEnd() ?? Data()
    return String(data: data, encoding: .utf8) ?? ""
}
