import Foundation

public struct TestResources {
    public init() {}

    public var resourceURL: URL? {
        return Bundle.module.resourceURL?.appendingPathComponent("Resources")
    }

    public var resourcePath: String? {
        return Bundle.module.resourcePath?.appending("/Resources")
    }

    public func getJsonUrl(_ jsonPath: String) -> URL? {
        return Bundle.module.url(forResource: "Resources/\(jsonPath)", withExtension: "json")
    }
}
