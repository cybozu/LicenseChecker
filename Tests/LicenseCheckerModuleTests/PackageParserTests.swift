import Testing
import TestResources
@testable import LicenseCheckerModule

struct PackageParserTests {
    let testResources = TestResources()

    @Test("If workspace-state is normal, PackageParser initialization succeeds.")
    func init_PackageParser_success() async throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try #require(testResources.getJsonUrl(jsonPath))
        
        let actual = PackageParser(url: jsonURL)
        #expect(actual != nil)
    }
    
    @Test("If workspace-state is broken, PackageParser initialization fails.")
    func init_PackageParser_failure() async throws {
        let jsonPath = "SourcePackagesWorkspaceStateBroken/workspace-state"
        let jsonURL = try #require(testResources.getJsonUrl(jsonPath))
        
        let actual = PackageParser(url: jsonURL)
        #expect(actual == nil)
    }
    
    @Test(
        "The license file is successfully extracted.",
        arguments: [LicenseType.apache, .mit, .bsd, .zlib, .boringSSL]
    )
    func extractLicense(_ licenseType: LicenseType) async throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try #require(testResources.getJsonUrl(jsonPath))
        let packageParser = try #require(PackageParser(url: jsonURL))
        let resourceURL = try #require(testResources.resourceURL)
        let directoryURL = resourceURL.appendingPathComponent(licenseType.containerDirectoryName)
            .appendingPathComponent("checkouts")
            .appendingPathComponent(licenseType.packageDirectoryName)
        let actual = packageParser.extractLicense(directoryURL: directoryURL)
        #expect(actual == licenseType)
    }
    
    @Test(
        "The licence file is successfully extracted.",
        arguments: [LicenseType.apache, .mit]
    )
    func extractLicence(_ licenseType: LicenseType) async throws {
        let jsonPath = "SourcePackagesUnknown/workspace-state"
        let jsonURL = try #require(testResources.getJsonUrl(jsonPath))
        let packageParser = try #require(PackageParser(url: jsonURL))
        let resourceURL = try #require(testResources.resourceURL)
        let directoryURL = resourceURL.appendingPathComponent("SourcePackagesLICENCE")
            .appendingPathComponent("checkouts")
            .appendingPathComponent(licenseType.packageDirectoryName)
        let actual = packageParser.extractLicense(directoryURL: directoryURL)
        #expect(actual == licenseType)
    }
    
    @Test(
        "The license file is successfully parsed.",
        arguments: [LicenseType.apache, .mit, .bsd, .zlib, .boringSSL]
    )
    func parseLicense(_ licenseType: LicenseType) async throws {
        let jsonPath = "\(licenseType.containerDirectoryName)/workspace-state"
        let jsonURL = try #require(testResources.getJsonUrl(jsonPath))
        let packageParser = try #require(PackageParser(url: jsonURL))

        let resourcePath = try #require(testResources.resourcePath)
        let checkoutsPath = "\(resourcePath)/\(licenseType.containerDirectoryName)/checkouts"
        let whiteListDummy = WhiteList(licenses: nil, libraries: nil)
        let actual = packageParser.parse(with: checkoutsPath, whiteList: whiteListDummy)

        let expect = Acknowledgement(
            libraryName: licenseType.packageDirectoryName,
            licenseType: licenseType,
            isForbidden: true
        )
        #expect(actual == [expect])
    }
}
