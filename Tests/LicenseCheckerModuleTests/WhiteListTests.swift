import XCTest
import TestResources
@testable import LicenseCheckerModule

final class WhiteListTests: XCTestCase {

    func getJsonUrl(_ jsonName: String) -> URL? {
        return Bundle.module.url(forResource: jsonName, withExtension: "json")
    }

    func test_load_broken_white_list() throws {
        let jsonURL = try XCTUnwrap(getJsonUrl("white-list-broken"))

        let sut = WhiteList.load(url: jsonURL)
        XCTAssertNil(sut)
    }


    func test_load_empty_white_list() throws {
        let jsonURL = try XCTUnwrap(getJsonUrl("white-list-empty"))

        let sut = WhiteList.load(url: jsonURL)
        XCTAssertNotNil(sut)

        let actual = try XCTUnwrap(sut)
        XCTAssertNotNil(actual.licenses)
        XCTAssertEqual(actual.licenses?.isEmpty, true)
        XCTAssertNotNil(actual.libraries)
        XCTAssertEqual(actual.libraries?.isEmpty, true)
    }

    func test_load_licenses() throws {
        let jsonURL = try XCTUnwrap(getJsonUrl("white-list-one-license"))

        let sut = WhiteList.load(url: jsonURL)
        XCTAssertNotNil(sut)

        let actual = try XCTUnwrap(sut)
        XCTAssertEqual(actual.licenses, ["Apache"])
        XCTAssertNil(actual.libraries)
    }

    func test_load_libraries() throws {
        let jsonURL = try XCTUnwrap(getJsonUrl("white-list-one-library"))

        let sut = WhiteList.load(url: jsonURL)
        XCTAssertNotNil(sut)

        let actual = try XCTUnwrap(sut)
        XCTAssertNil(actual.licenses)
        XCTAssertEqual(actual.libraries, ["some-package"])
    }
}
