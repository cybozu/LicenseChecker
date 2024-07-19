import Foundation
import PackagePlugin

@main
struct LicenseCheckerPlugin: BuildToolPlugin {
    struct SourcePackagesNotFoundError: Error & CustomStringConvertible {
        let description: String = "error: SourcePackages not found"
    }

    func sourcePackages(_ pluginWorkDirectory: Path) throws -> Path {
        var tmpPath = pluginWorkDirectory
        guard pluginWorkDirectory.string.contains("SourcePackages") else {
            throw SourcePackagesNotFoundError()
        }
        while tmpPath.lastComponent != "SourcePackages" {
            tmpPath = tmpPath.removingLastComponent()
        }
        return tmpPath
    }

    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let executablePath = try context.tool(named: "license-checker").path
        let sourcePackagesPath = try sourcePackages(context.pluginWorkDirectory)
        let whiteListPath = context.package.directory.appending(subpath: "white-list.json")

        return [
            .buildCommand(
                displayName: "Check License",
                executable: executablePath,
                arguments: [
                    "--source-packages-path",
                    sourcePackagesPath.string,
                    "--white-list-path",
                    whiteListPath.string
                ],
                outputFiles: [
                    context.pluginWorkDirectory
                ]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

/// This command works with `Run Build Tool Plug-ins` in Xcode `Build Phase`.
extension LicenseCheckerPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let executablePath = try context.tool(named: "license-checker").path
        let sourcePackagesPath = try sourcePackages(context.pluginWorkDirectory)
        let whiteListPath = context.xcodeProject.directory.appending(subpath: "white-list.json")

        return [
            .buildCommand(
                displayName: "Check License",
                executable: executablePath,
                arguments: [
                    "--source-packages-path",
                    sourcePackagesPath.string,
                    "--white-list-path",
                    whiteListPath.string
                ],
                outputFiles: [
                    context.pluginWorkDirectory
                ]
            )
        ]
    }
}

#endif
