import Foundation

public struct WhiteList: Decodable {
    var licenses: [String]?
    var libraries: [String]?

    public init(licenses: [String]?, libraries: [String]?) {
        self.licenses = licenses
        self.libraries = libraries
    }

    private init?(url: URL) {
        guard let data = try? Data(contentsOf: url),
              let whiteList = try? JSONDecoder().decode(WhiteList.self, from: data) else {
            return nil
        }
        self = whiteList
    }

    public func contains(libraryID: String, licenseType: LicenseType) -> Bool {
        if let libraries, libraries.contains(libraryID) {
            true
        } else if licenseType == .unknown {
            false
        } else if let licenses {
            licenses.map({ $0.lowercased() }).contains(licenseType.lowercased)
        } else {
            false
        }
    }

    static func load(url: URL) -> WhiteList? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(WhiteList.self, from: data)
    }
}
