import Foundation

public struct WhiteList: Decodable {
    let licenses: [String]?
    let libraries: [String]?

    public init(licenses: [String]?, libraries: [String]?) {
        self.licenses = licenses
        self.libraries = libraries
    }

    private init?(url: URL) {
        guard let data = try? Data(contentsOf: url),
              let whiteList = try? JSONDecoder().decode(WhiteList.self, from: data)
        else { return nil }
        self = whiteList
    }

    public func contains(_ libraryName: String, licenseType: LicenseType) -> Bool {
        if let libraries, libraries.contains(libraryName) {
            return true
        }
        if licenseType == .unknown {
            return false
        }
        if let licenses {
            return licenses.map({ $0.lowercased() }).contains(licenseType.lowercased)
        }
        return false
    }

    static func load(url: URL) -> WhiteList? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(WhiteList.self, from: data)
    }
}
