import ArgumentParser
import Darwin
import LicenseCheckerModule

struct LicenseChecker: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "license-checker",
        abstract: "A tool to check license of swift package libraries.",
        version: "1.0.0"
    )

    @Option(
        name: [.customShort("s"), .customLong("source-packages-path")],
        help: "Path to SourcePackages directory"
    )
    var sourcePackagesPath: String

    @Option(
        name: [.customShort("w"), .customLong("white-list-path")],
        help: "Path to white-list.json"
    )
    var whiteListPath: String

    mutating func run() throws {
        do {
            try LCMain().run(
                sourcePackagesPath: self.sourcePackagesPath,
                whiteListPath: self.whiteListPath
            )
        } catch let error as LCError {
            Swift.print("error:", error.errorDescription!)
            Darwin.exit(error.exitCode)
        }
    }
}
