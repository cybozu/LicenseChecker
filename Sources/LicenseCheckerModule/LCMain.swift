import Foundation

public final class LCMain {
    public init() {}

    public func run(sourcePackagesPath: String, whiteListPath: String, verbose: Bool, quiet: Bool, tab: Bool) throws {
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
        var acknowledgements = packageParser.parse(with: checkoutsPath, whiteList: whiteList)
        
        if quiet {
            acknowledgements = acknowledgements.filter { $0.isForbidden }
        }
        
        if tab {
            printAcknowledgmentsWithTabs(acknowledgements, verbose: verbose)
        } else {
            printAcknowledgments(acknowledgements, verbose: verbose)
        }
        guard acknowledgements.allSatisfy({ $0.isForbidden == false }) else {
            throw LCError.forbiddenLibraryFound
        }
        Swift.print("✅ No problems with library licensing.")
    }

    func printAcknowledgments(_ acknowledgements: [Acknowledgement], verbose: Bool) {
        let nameLength = acknowledgements.reduce(0) { max($0, $1.libraryName.count) }
        let licenseLength = acknowledgements.reduce(0) { max($0, $1.licenseType.rawValue.count) }

        acknowledgements.forEach { acknowledgement in
            let mark = acknowledgement.isForbidden ? "×" : "✔︎"
            let library = acknowledgement.libraryName
                .padding(toLength: nameLength, withPad: " ", startingAt: 0)
            if verbose {
                let license = acknowledgement.licenseType.rawValue
                    .padding(toLength: licenseLength, withPad: " ", startingAt: 0)
                Swift.print(mark, library, license, acknowledgement.location)
            } else {
                Swift.print(mark, library, acknowledgement.licenseType.rawValue)
            }
        }
    }

    func printAcknowledgmentsWithTabs(_ acknowledgements: [Acknowledgement], verbose: Bool) {
        acknowledgements.forEach { acknowledgement in
            let mark = acknowledgement.isForbidden ? "×" : "✔︎"
            
            var row = [
                mark,
                acknowledgement.libraryName,
                acknowledgement.licenseType.rawValue
            ]
            if verbose {
                row.append(acknowledgement.location)
            }
            Swift.print(row.joined(separator: "\t"))
        }
    }
    
}
