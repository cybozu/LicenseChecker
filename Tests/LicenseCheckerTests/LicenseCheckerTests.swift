import Foundation
import Testing
import TestResources

struct LicenseCheckerTests {
    private let testResources = TestResources()
    
    /// Returns path to the built products directory.
    private var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }
    
    @Test("If executed with invalid arguments, the command exits with instructions on how to use it.")
    func pass_invalid_arguments() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardError = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        
        let expect = """
        Error: Missing expected argument '--source-packages-path <source-packages-path>'

        OVERVIEW: A tool to check license of swift package libraries.

        USAGE: license-checker --source-packages-path <source-packages-path> --white-list-path <white-list-path>

        OPTIONS:
          -s, --source-packages-path <source-packages-path>
                                  Path to SourcePackages directory
          -w, --white-list-path <white-list-path>
                                  Path to white-list.json
          --version               Show the version.
          -h, --help              Show help information.\n\n
        """
        #expect(output == expect)
        #expect(process.terminationStatus == 64)
    }
    
    @Test(
        "If the license type is contained in the whitelist, the command exits normally.",
        arguments: [
            "SourcePackagesApache",
            "SourcePackagesMIT",
            "SourcePackagesBSD",
            "SourcePackagesZlib",
            "SourcePackagesBoringSSL",
        ]
    )
    func check_license(_ directoryName: String) throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try #require(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent(directoryName)
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.absolutePath, "-w", whiteListURL.absolutePath]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try #require(String(data: data, encoding: .utf8))

        #expect(output.hasSuffix("✅ No problems with library licensing.\n"))
        #expect(process.terminationStatus == 0)
    }
    
    @Test("If the library name is contained in the whitelist, the command exits normally.")
    func check_library() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try #require(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesSomePackage")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.absolutePath, "-w", whiteListURL.absolutePath]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try #require(String(data: data, encoding: .utf8))

        #expect(output.hasSuffix("✅ No problems with library licensing.\n"))
        #expect(process.terminationStatus == 0)
    }
    
    @Test("If the workspace-state.json is broken, the command exits with error message.")
    func pass_broken_workspace_state() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try #require(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesWorkspaceStateBroken")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.absolutePath, "-w", whiteListURL.absolutePath]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try #require(String(data: data, encoding: .utf8))

        #expect(output.hasSuffix("error: Couldn't load workspace-state.json\n"))
        #expect(process.terminationStatus == 1)
    }
    
    @Test("If the white-list.json is broken, the command exits with error message.")
    func pass_broken_white_list() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try #require(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesWhiteListBroken")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.absolutePath, "-w", whiteListURL.absolutePath]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try #require(String(data: data, encoding: .utf8))

        #expect(output.hasSuffix("error: Couldn't load white-list.json\n"))
        #expect(process.terminationStatus == 2)
    }
    
    @Test("If an unknown type of license is found, the command exits with error message.")
    func check_unknown_license() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try #require(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesUnknown")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.absolutePath, "-w", whiteListURL.absolutePath]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try #require(String(data: data, encoding: .utf8))

        #expect(output.hasSuffix("error: Library with forbidden license is found.\n"))
        #expect(process.terminationStatus == 3)
    }
}

private extension URL {
    var absolutePath: String { absoluteURL.path() }
}
