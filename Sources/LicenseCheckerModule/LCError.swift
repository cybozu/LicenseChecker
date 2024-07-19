import Foundation

public enum LCError: Error, LocalizedError {
    case notLoadedWorkspaceState
    case notLoadedWhiteList
    case forbiddenLibraryFound

    public var errorDescription: String? {
        switch self {
        case .notLoadedWorkspaceState:
            return "error: Couldn't load workspace-state.json"
        case .notLoadedWhiteList:
            return "error: Couldn't load white-list.json"
        case .forbiddenLibraryFound:
            return "error: Library with forbidden license is found."
        }
    }
}
