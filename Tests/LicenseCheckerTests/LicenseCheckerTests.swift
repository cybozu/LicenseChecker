import XCTest
import TestResources

final class LicenseCheckerTests: XCTestCase {
    let testResources = TestResources()

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    func test_invalid_args() throws {
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
        XCTAssertEqual(output, expect)
        XCTAssertEqual(process.terminationStatus, 64)
    }

    func test_Apache() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesApache")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.path, "-w", whiteListURL.path]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try XCTUnwrap(String(data: data, encoding: .utf8))

        XCTAssertTrue(output.hasSuffix("✅ No problems with library licensing.\n"))
        XCTAssertEqual(process.terminationStatus, 0)
    }

    func test_MIT() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesMIT")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.path, "-w", whiteListURL.path]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try XCTUnwrap(String(data: data, encoding: .utf8))

        XCTAssertTrue(output.hasSuffix("✅ No problems with library licensing.\n"))
        XCTAssertEqual(process.terminationStatus, 0)
    }

    func test_BSD() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesBSD")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.path, "-w", whiteListURL.path]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try XCTUnwrap(String(data: data, encoding: .utf8))

        XCTAssertTrue(output.hasSuffix("✅ No problems with library licensing.\n"))
        XCTAssertEqual(process.terminationStatus, 0)
    }

    func test_zlib() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesZlib")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.path, "-w", whiteListURL.path]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try XCTUnwrap(String(data: data, encoding: .utf8))

        XCTAssertTrue(output.hasSuffix("✅ No problems with library licensing.\n"))
        XCTAssertEqual(process.terminationStatus, 0)
    }

    func test_BoringSSL() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesBoringSSL")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.path, "-w", whiteListURL.path]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try XCTUnwrap(String(data: data, encoding: .utf8))

        XCTAssertTrue(output.hasSuffix("✅ No problems with library licensing.\n"))
        XCTAssertEqual(process.terminationStatus, 0)
    }

    func test_SomePackage() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesSomePackage")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.path, "-w", whiteListURL.path]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try XCTUnwrap(String(data: data, encoding: .utf8))

        XCTAssertTrue(output.hasSuffix("✅ No problems with library licensing.\n"))
        XCTAssertEqual(process.terminationStatus, 0)
    }

    func test_workspace_state_broken() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardError = pipe
        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesWorkspaceStateBroken")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.path, "-w", whiteListURL.path]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try XCTUnwrap(String(data: data, encoding: .utf8))

        XCTAssertTrue(output.hasSuffix("🚨 Couldn't load workspace-state.json\n"))
        XCTAssertEqual(process.terminationStatus, 1)
    }

    func test_white_list_broken() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardError = pipe
        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesWhiteListBroken")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.path, "-w", whiteListURL.path]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try XCTUnwrap(String(data: data, encoding: .utf8))

        XCTAssertTrue(output.hasSuffix("🚨 Couldn't load white-list.json\n"))
        XCTAssertEqual(process.terminationStatus, 1)
    }

    func test_unknown_license() throws {
        let licenseCheckerBinary = productsDirectory.appendingPathComponent("license-checker")
        let process = Process()
        process.executableURL = licenseCheckerBinary
        let pipe = Pipe()
        process.standardError = pipe
        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let sourcePackagesURL = resourceURL.appendingPathComponent("SourcePackagesUnknown")
        let whiteListURL = sourcePackagesURL.appendingPathComponent("white-list.json")
        process.arguments = ["-s", sourcePackagesURL.path, "-w", whiteListURL.path]
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = try XCTUnwrap(String(data: data, encoding: .utf8))

        XCTAssertTrue(output.hasSuffix("🚨 Library with forbidden license is found.\n"))
        XCTAssertEqual(process.terminationStatus, 1)
    }
}
