import Foundation

public struct TestResources {
    public init() {}

    public var resourceURL: URL? {
        Bundle.module.resourceURL?.appendingPathComponent("Resources")
    }

    public var resourcePath: String? {
        Bundle.module.resourcePath?.appending("/Resources")
    }

    public func getJsonUrl(_ jsonPath: String) -> URL? {
        Bundle.module.url(forResource: "Resources/\(jsonPath)", withExtension: "json")
    }
}
