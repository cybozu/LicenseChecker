import Foundation

public enum LCError: Error, LocalizedError {
    case notLoadedWorkspaceState
    case notLoadedWiteList
    case forbiddenLibraryFound

    public var errorDescription: String? {
        switch self {
        case .notLoadedWorkspaceState:
            return "🚨 Couldn't load workspace-state.json"
        case .notLoadedWiteList:
            return "🚨 Couldn't load white-list.json"
        case .forbiddenLibraryFound:
            return "🚨 Library with forbidden license is found."
        }
    }
}
