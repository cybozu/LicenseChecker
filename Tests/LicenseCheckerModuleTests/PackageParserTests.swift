import XCTest
import TestResources
@testable import LicenseCheckerModule

final class PackageParserTests: XCTestCase {
    let testResources = TestResources()
    let whiteListDummy = WhiteList(licenses: nil, libraries: nil)

    func test_init_PackageParser_success() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))

        let sut = PackageParser(url: jsonURL)
        XCTAssertNotNil(sut)
    }

    func test_init_PackageParser_failure() throws {
        let jsonPath = "SourcePackagesWorkspaceStateBroken/workspace-state"
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
            .appendingPathComponent("apache-package")

        let sut = packageParser.extractLicense(dirURL: dirURL)
        XCTAssertEqual(sut, LicenseType.apache)
    }

    func test_parse_apache() throws {
        let jsonPath = "SourcePackagesApache/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourcePath = try XCTUnwrap(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/SourcePackagesApache/checkouts"
        let sut = packageParser.parse(with: checkoutsPath, whiteList: whiteListDummy)

        let expect = Acknowledgement(libraryName: "apache-package",
                                     licenseType: .apache,
                                     isForbidden: true)
        XCTAssertEqual(sut, [expect])
    }

    // MIT
    func test_extractLicense_mit() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let dirURL = resourceURL.appendingPathComponent("SourcePackagesMIT")
            .appendingPathComponent("checkouts")
            .appendingPathComponent("mit-package")

        let sut = packageParser.extractLicense(dirURL: dirURL)
        XCTAssertEqual(sut, LicenseType.mit)
    }

    func test_parse_mit() throws {
        let jsonPath = "SourcePackagesMIT/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourcePath = try XCTUnwrap(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/SourcePackagesMIT/checkouts"
        let sut = packageParser.parse(with: checkoutsPath, whiteList: whiteListDummy)

        let expect = Acknowledgement(libraryName: "mit-package",
                                     licenseType: .mit,
                                     isForbidden: true)
        XCTAssertEqual(sut, [expect])
    }

    // BSD
    func test_extractLicense_bsd() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let dirURL = resourceURL.appendingPathComponent("SourcePackagesBSD")
            .appendingPathComponent("checkouts")
            .appendingPathComponent("bsd-package")

        let sut = packageParser.extractLicense(dirURL: dirURL)
        XCTAssertEqual(sut, LicenseType.bsd)
    }

    func test_parse_bsd() throws {
        let jsonPath = "SourcePackagesBSD/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourcePath = try XCTUnwrap(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/SourcePackagesBSD/checkouts"
        let sut = packageParser.parse(with: checkoutsPath, whiteList: whiteListDummy)

        let expect = Acknowledgement(libraryName: "bsd-package",
                                     licenseType: .bsd,
                                     isForbidden: true)
        XCTAssertEqual(sut, [expect])
    }

    // zlib
    func test_extractLicense_zlib() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let dirURL = resourceURL.appendingPathComponent("SourcePackagesZlib")
            .appendingPathComponent("checkouts")
            .appendingPathComponent("zlib-package")

        let sut = packageParser.extractLicense(dirURL: dirURL)
        XCTAssertEqual(sut, LicenseType.zlib)
    }

    func test_parse_zlib() throws {
        let jsonPath = "SourcePackagesZlib/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourcePath = try XCTUnwrap(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/SourcePackagesZlib/checkouts"
        let sut = packageParser.parse(with: checkoutsPath, whiteList: whiteListDummy)

        let expect = Acknowledgement(libraryName: "zlib-package",
                                     licenseType: .zlib,
                                     isForbidden: true)
        XCTAssertEqual(sut, [expect])
    }

    // BoringSSL
    func test_extractLicense_boringssl() throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourceURL = try XCTUnwrap(testResources.resourceURL)
        let dirURL = resourceURL.appendingPathComponent("SourcePackagesBoringSSL")
            .appendingPathComponent("checkouts")
            .appendingPathComponent("boringssl-package")

        let sut = packageParser.extractLicense(dirURL: dirURL)
        XCTAssertEqual(sut, LicenseType.boringSSL)
    }

    func test_parse_boringssl() throws {
        let jsonPath = "SourcePackagesBoringSSL/workspace-state"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))
        let packageParser = try XCTUnwrap(PackageParser(url: jsonURL))

        let resourcePath = try XCTUnwrap(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/SourcePackagesBoringSSL/checkouts"
        let sut = packageParser.parse(with: checkoutsPath, whiteList: whiteListDummy)

        let expect = Acknowledgement(libraryName: "boringssl-package",
                                     licenseType: .boringSSL,
                                     isForbidden: true)
        XCTAssertEqual(sut, [expect])
    }
}
