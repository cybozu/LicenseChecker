import Foundation

public final class LCMain {
    public init() {}

    public func run(sourcePackagesPath: String, whiteListPath: String) throws {
        let workspaceStateURL = URL(fileURLWithPath: sourcePackagesPath)
            .appendingPathComponent("workspace-state.json")
        let checkoutsPath = "\(sourcePackagesPath)/checkouts"
        guard let packageParser = PackageParser(url: workspaceStateURL) else {
            throw LCError.notLoadedWorkspaceState
        }
        let whiteListURL = URL(fileURLWithPath: whiteListPath)
        guard let whiteList = WhiteList.load(url: whiteListURL) else {
            throw LCError.notLoadedWhiteList
        }
        let acknowledgements = packageParser.parse(with: checkoutsPath, whiteList: whiteList)
        printAcknowledgments(acknowledgements)
        guard acknowledgements.allSatisfy({ $0.isForbidden == false }) else {
            throw LCError.forbiddenLibraryFound
        }
        Swift.print("✅ No problems with library licensing.")
    }

    func printAcknowledgments(_ acknowledgements: [Acknowledgement]) {
        let length = acknowledgements.max {
            $0.libraryName.count < $1.libraryName.count
        }?.libraryName.count ?? 0
        acknowledgements.forEach { acknowledgement in
            let mark = acknowledgement.isForbidden ? "×" : "✔︎"
            let library = acknowledgement.libraryName
                .padding(toLength: length, withPad: " ", startingAt: 0)
            Swift.print(mark, library, acknowledgement.licenseType.rawValue)
        }
    }
}
