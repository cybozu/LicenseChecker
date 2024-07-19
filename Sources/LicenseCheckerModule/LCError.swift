import Foundation

public enum LCError: LocalizedError {
    case notLoadedWorkspaceState
    case notLoadedWhiteList
    case forbiddenLibraryFound

    public var errorDescription: String? {
        switch self {
        case .notLoadedWorkspaceState:
            "Couldn't load workspace-state.json"
        case .notLoadedWhiteList:
            "Couldn't load white-list.json"
        case .forbiddenLibraryFound:
            "Library with forbidden license is found."
        }
    }

    public var exitCode: Int32 {
        switch self {
        case .notLoadedWorkspaceState: 1
        case .notLoadedWhiteList: 2
        case .forbiddenLibraryFound: 3
        }
    }
}
