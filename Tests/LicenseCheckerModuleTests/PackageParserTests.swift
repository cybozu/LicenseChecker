import XCTest
import TestResources
@testable import LicenseCheckerModule

final class PackageParserTests: XCTestCase {
    let testResources = TestResources()

    func test_init_PackageParser_success() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))

        let sut = PackageParser(url: jsonURL)
        XCTAssertNotNil(sut)
    }

    func test_init_PackageParser_failure() throws {
        let jsonPath = "SourcePackagesBroken/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))

        let sut = PackageParser(url: jsonURL)
        XCTAssertNil(sut)
    }

    // Apache
    func test_extractLicense_apache() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let dirURL = resourceURL.appendingPathComponent("SourcePackagesApache")
            .appendingPathComponent("checkouts")
            .appendingPathComponent("swift-collections")

        let sut = packageParser.extractLicense(dirURL: dirURL)
        XCTAssertEqual(sut, "Apache")
    }

    func test_parse_apache() throws {
        let jsonPath = "SourcePackagesApache/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourcePath = try XCTUnwrap(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/SourcePackagesApache/checkouts"
        let sut = packageParser.parse(with: checkoutsPath)

        let expect = [Acknowledgement(libraryName: "swift-collections", license: "Apache")]
        XCTAssertEqual(sut, expect)
    }

    // MIT
    func test_extractLicense_mit() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let dirURL = resourceURL.appendingPathComponent("SourcePackagesMIT")
            .appendingPathComponent("checkouts")
            .appendingPathComponent("LicenseList")

        let sut = packageParser.extractLicense(dirURL: dirURL)
        XCTAssertEqual(sut, "MIT")
    }

    func test_parse_mit() throws {
        let jsonPath = "SourcePackagesMIT/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourcePath = try XCTUnwrap(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/SourcePackagesMIT/checkouts"
        let sut = packageParser.parse(with: checkoutsPath)

        let expect = [Acknowledgement(libraryName: "LicenseList", license: "MIT")]
        XCTAssertEqual(sut, expect)
    }

    // BSD
    func test_extractLicense_bsd() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let dirURL = resourceURL.appendingPathComponent("SourcePackagesBSD")
            .appendingPathComponent("checkouts")
            .appendingPathComponent("SwiftAssimp")

        let sut = packageParser.extractLicense(dirURL: dirURL)
        XCTAssertEqual(sut, "BSD")
    }

    func test_parse_bsd() throws {
        let jsonPath = "SourcePackagesBSD/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourcePath = try XCTUnwrap(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/SourcePackagesBSD/checkouts"
        let sut = packageParser.parse(with: checkoutsPath)

        let expect = [Acknowledgement(libraryName: "Assimp", license: "BSD")]
        XCTAssertEqual(sut, expect)
    }

    // zlib
    func test_extractLicense_zlib() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let dirURL = resourceURL.appendingPathComponent("SourcePackagesZlib")
            .appendingPathComponent("checkouts")
            .appendingPathComponent("nanopb")

        let sut = packageParser.extractLicense(dirURL: dirURL)
        XCTAssertEqual(sut, "zlib")
    }

    func test_parse_zlib() throws {
        let jsonPath = "SourcePackagesZlib/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourcePath = try XCTUnwrap(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/SourcePackagesZlib/checkouts"
        let sut = packageParser.parse(with: checkoutsPath)

        let expect = [Acknowledgement(libraryName: "nanopb", license: "zlib")]
        XCTAssertEqual(sut, expect)
    }

    // BoringSSL
    func test_extractLicense_boringssl() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let dirURL = resourceURL.appendingPathComponent("SourcePackagesBoringSSL")
            .appendingPathComponent("checkouts")
            .appendingPathComponent("boringSSL-SwiftPM")

        let sut = packageParser.extractLicense(dirURL: dirURL)
        XCTAssertEqual(sut, "BoringSSL")
    }

    func test_parse_boringssl() throws {
        let jsonPath = "SourcePackagesBoringSSL/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourcePath = try XCTUnwrap(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/SourcePackagesBoringSSL/checkouts"
        let sut = packageParser.parse(with: checkoutsPath)

        let expect = [Acknowledgement(libraryName: "BoringSSL-GRPC", license: "BoringSSL")]
        XCTAssertEqual(sut, expect)
    }
}
