import Foundation

public struct PackageParser {
    private var workspaceState: WorkspaceState

    public init?(url: URL) {
        guard let data = try? Data(contentsOf: url),
              let workspaceState = try? JSONDecoder().decode(WorkspaceState.self, from: data) else {
            return nil
        }
        self.workspaceState = workspaceState
    }

    public func parse(with checkoutsPath: String, whiteList: WhiteList) -> [Acknowledgement] {
        workspaceState.object.dependencies
            .map { dependency in
                let components = dependency.packageRef.location.components(separatedBy: "/")
                let repositoryName = components.last!.replacingOccurrences(of: ".git", with: "")
                let directoryURL = URL(fileURLWithPath: checkoutsPath).appendingPathComponent(repositoryName)
                let libraryName = dependency.packageRef.name
                let licenseType = extractLicense(directoryURL: directoryURL)
                let isForbidden = !whiteList.contains(libraryName, licenseType: licenseType)
                return Acknowledgement(
                    libraryName: libraryName,
                    licenseType: licenseType,
                    isForbidden: isForbidden,
                    location: dependency.packageRef.location
                )
            }
            .sorted { $0.libraryName.lowercased() < $1.libraryName.lowercased() }
    }

    public func extractLicense(directoryURL: URL) -> LicenseType {
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
        return LicenseType(text: text.replace(of: #"(  +|\n)"#, with: " "))
    }
}
