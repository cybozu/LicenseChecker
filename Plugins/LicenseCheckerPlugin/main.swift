import Foundation
import PackagePlugin

@main
struct LicenseCheckerPlugin: BuildToolPlugin {
    struct SourcePackagesNotFoundError: Error & CustomStringConvertible {
        let description: String = "SourcePackages not found"
    }

    func existsSourcePackages(in url: URL) throws -> Bool {
        guard url.isFileURL,
              url.pathComponents.count > 1,
              let isDirectory = try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory else {
            throw SourcePackagesNotFoundError()
        }
        let existsSourcePackagesInDirectory = FileManager.default
            .fileExists(atPath: url.appending(path: "SourcePackages").path())
        return isDirectory && existsSourcePackagesInDirectory
    }

    func sourcePackages(_ pluginWorkDirectory: URL) throws -> URL {
        var tmpURL = pluginWorkDirectory.absoluteURL

        while try !existsSourcePackages(in: tmpURL) {
            tmpURL.deleteLastPathComponent()
        }
        tmpURL.append(path: "SourcePackages")
        return tmpURL
    }

    func makeBuildCommand(executableURL: URL, sourcePackagesURL: URL, whiteListURL: URL, outputURL: URL) -> Command {
        .buildCommand(
            displayName: "Check License",
            executable: executableURL,
            arguments: [
                "--source-packages-path",
                sourcePackagesURL.absoluteURL.path(),
                "--white-list-path",
                whiteListURL.absoluteURL.path()
            ],
            outputFiles: [
                outputURL
            ]
        )
    }

    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        [
            makeBuildCommand(
                executableURL: try context.tool(named: "license-checker").url,
                sourcePackagesURL: try sourcePackages(context.pluginWorkDirectoryURL),
                whiteListURL: context.package.directoryURL.appending(path: "white-list.json"),
                outputURL: context.pluginWorkDirectoryURL
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

/// This command works with `Run Build Tool Plug-ins` in Xcode `Build Phase`.
extension LicenseCheckerPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        [
            makeBuildCommand(
                executableURL: try context.tool(named: "license-checker").url,
                sourcePackagesURL: try sourcePackages(context.pluginWorkDirectoryURL),
                whiteListURL: context.xcodeProject.directoryURL.appending(path: "white-list.json"),
                outputURL: context.pluginWorkDirectoryURL
            )
        ]
    }
}

#endif
