import ArgumentParser
import LicenseCheckerModule

struct LicenseChecker: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "license-checker",
        abstract: "A tool to check license of swift package libraries.",
        version: "1.0.0"
    )

    @Option(
        name: [.customShort("s"), .customLong("source-packages-path")],
        help: "Path of SourcePackages directory"
    )
    var sourcePackagesPath: String

    @Option(
        name: [.customShort("w"), .customLong("white-list-path")],
        help: "Path of white-list.json"
    )
    var whiteListPath: String

    mutating func run() throws {
        try LCMain().run(
            sourcePackagesPath: self.sourcePackagesPath,
            whiteListPath: self.whiteListPath
        )
    }
}
