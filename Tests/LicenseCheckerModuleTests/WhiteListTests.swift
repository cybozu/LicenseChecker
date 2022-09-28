import XCTest
import TestResources
@testable import LicenseCheckerModule

final class WhiteListTests: XCTestCase {
    let testResources = TestResources()

    func test_load_broken_white_list() throws {
        let jsonPath = "SourcePackagesWhiteListBroken/white-list"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))

        let sut = WhiteList.load(url: jsonURL)
        XCTAssertNil(sut)
    }


    func test_load_empty_white_list() throws {
        let jsonPath = "SourcePackagesUnknown/white-list"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))

        let sut = WhiteList.load(url: jsonURL)
        XCTAssertNotNil(sut)

        let actual = try XCTUnwrap(sut)
        XCTAssertTrue(actual.licenses.isEmpty)
        XCTAssertTrue(actual.libraries.isEmpty)
    }

    func test_load_licenses() throws {
        let jsonPath = "SourcePackagesApache/white-list"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))

        let sut = WhiteList.load(url: jsonURL)
        XCTAssertNotNil(sut)

        let actual = try XCTUnwrap(sut)
        XCTAssertEqual(actual.licenses, ["Apache"])
        XCTAssertTrue(actual.libraries.isEmpty)
    }

    func test_load_libraries() throws {
        let jsonPath = "SourcePackagesSomePackage/white-list"
        let jsonURL = try XCTUnwrap(testResources.getJsonUrl(jsonPath))

        let sut = WhiteList.load(url: jsonURL)
        XCTAssertNotNil(sut)

        let actual = try XCTUnwrap(sut)
        XCTAssertTrue(actual.licenses.isEmpty)
        XCTAssertEqual(actual.libraries, ["some-package"])
    }
}
