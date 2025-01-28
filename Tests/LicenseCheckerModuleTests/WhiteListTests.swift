import Foundation
import Testing
@testable import LicenseCheckerModule

struct WhiteListTests {
    private func getJsonUrl(_ jsonName: String) -> URL? {
        Bundle.module.url(forResource: jsonName, withExtension: "json")
    }
    
    @Test("If the whitelist is broken, loading fails.")
    func load_broken_white_list_failure() throws {
        let jsonURL = try #require(getJsonUrl("white-list-broken"))
        let actual = WhiteList.load(url: jsonURL)
        #expect(actual == nil)
    }
    
    @Test("If the whitelist is empty, loading succeeds.")
    func load_empty_white_list_success() throws {
        let jsonURL = try #require(getJsonUrl("white-list-empty"))
        let actual = try #require(WhiteList.load(url: jsonURL))
        #expect(actual.licenses != nil)
        #expect(actual.licenses?.isEmpty == true)
        #expect(actual.libraries != nil)
        #expect(actual.libraries?.isEmpty == true)
    }
    
    @Test("If the whitelist is normal and contains a license, loading it succeeds.")
    func load_normal_white_list_with_license_success() throws {
        let jsonURL = try #require(getJsonUrl("white-list-one-license"))
        let actual = try #require(WhiteList.load(url: jsonURL))
        #expect(actual.licenses == ["Apache"])
        #expect(actual.libraries == nil)
    }
    
    @Test("If the whitelist is normal and contains a library, loading it succeeds.")
    func load_normal_white_list_with_library_success() throws {
        let jsonURL = try #require(getJsonUrl("white-list-one-library"))
        let actual = try #require(WhiteList.load(url: jsonURL))
        #expect(actual.licenses == nil)
        #expect(actual.libraries == ["some-package"])
    }
}
