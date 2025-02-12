import ArgumentParser
import Darwin
import LicenseCheckerModule

struct LicenseChecker: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "license-checker",
        abstract: "A tool to check license of swift package libraries.",
        version: "2.0.0"
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
    
    @Flag(
        name: [.customShort("v"), .customLong("verbose")],
        help: "Enable verbose output"
    )
    var verbose: Bool = false
    
    @Flag(
        name: [.customShort("q"), .customLong("quiet")],
        help: "Only show forbidden licenses"
    )
    var quiet: Bool = false
    
    @Flag(
        name: [.customShort("t"), .customLong("tab")],
        help: "Enable tab-separated output"
    )
    var tab: Bool = false

    mutating func run() throws {
        do {
            try LCMain().run(
                sourcePackagesPath: sourcePackagesPath,
                whiteListPath: whiteListPath,
                verbose: verbose,
                quiet: quiet,
                tab: tab
            )
        } catch let error as LCError {
            Swift.print("error:", error.errorDescription!)
            Darwin.exit(error.exitCode)
        }
    }
}
