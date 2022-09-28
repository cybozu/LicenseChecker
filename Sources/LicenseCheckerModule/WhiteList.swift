import Foundation

public struct WhiteList: Decodable {
    let licenses: [String]
    let libraries: [String]

    private init?(url: URL) {
        guard let data = try? Data(contentsOf: url),
              let whiteList = try? JSONDecoder().decode(WhiteList.self, from: data)
        else { return nil }
        self = whiteList
    }

    public func contains(_ acknowledgement: Acknowledgement) -> Bool {
        if acknowledgement.license == "unknown" {
            let satisfy = self.libraries.contains(acknowledgement.libraryName)
            if !satisfy {
                Swift.print(acknowledgement.libraryName, acknowledgement.license)
            }
            return satisfy
        }
        let satisfy = self.licenses
            .map({ $0.lowercased() })
            .contains(acknowledgement.license.lowercased())
        if !satisfy {
            Swift.print(acknowledgement.libraryName, acknowledgement.license)
        }
        return satisfy
    }

    static func load(url: URL) -> WhiteList? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(WhiteList.self, from: data)
    }
}
