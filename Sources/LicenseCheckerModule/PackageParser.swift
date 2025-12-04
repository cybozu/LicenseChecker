import Foundation

struct PackageParser {
    private var workspaceState: WorkspaceState

    init?(url: URL) {
        guard let data = try? Data(contentsOf: url),
              let workspaceState = try? JSONDecoder().decode(WorkspaceState.self, from: data) else {
            return nil
        }
        self.workspaceState = workspaceState
    }

    func parse(with checkoutsPath: String, whiteList: WhiteList) -> [Acknowledgement] {
        workspaceState.object.dependencies
            .map { dependency in
                let components = dependency.packageRef.location.components(separatedBy: "/")
                let repositoryName = components.last!.replacingOccurrences(of: ".git", with: "")
                let directoryURL = URL(fileURLWithPath: checkoutsPath).appendingPathComponent(repositoryName)
                let libraryName = dependency.packageRef.name
                let libraryID = dependency.packageRef.identity
                let licenseType = extractLicense(directoryURL: directoryURL)
                let isForbidden = !(whiteList.contains(libraryID: libraryID) || whiteList.contains(licenseType: licenseType))
                return Acknowledgement(
                    libraryName: libraryName,
                    licenseType: licenseType,
                    isForbidden: isForbidden
                )
            }
            .sorted { $0.libraryName.lowercased() < $1.libraryName.lowercased() }
    }

    func extractLicense(directoryURL: URL) -> LicenseType {
        let fm = FileManager.default
        let contents = (try? fm.contentsOfDirectory(atPath: directoryURL.absoluteURL.path())) ?? []
        let licenseURL = contents
            .map { directoryURL.appendingPathComponent($0) }
            .filter { contentURL in
                let fileName = contentURL.deletingPathExtension().lastPathComponent.lowercased()
                guard ["license", "licence"].contains(fileName) else {
                    return false
                }
                var isDirectory: ObjCBool = false
                fm.fileExists(atPath: contentURL.absoluteURL.path(), isDirectory: &isDirectory)
                return isDirectory.boolValue == false
            }
            .first
        guard let licenseURL, let text = try? String(contentsOf: licenseURL) else {
            return .unknown
        }
        return LicenseType(text: text.replacing(of: #"(  +|\n)"#, with: " "))
    }
}
