# LicenseChecker

LicenseChecker is a command line tool checking licenses of swift package libraries that your app depends on.  
It can detect libraries that are not included in a whitelist specifying the license type or library name.

[![Github issues](https://img.shields.io/github/issues/cybozu/LicenseChecker)](https://github.com/cybozu/LicenseChecker/issues)
[![Github forks](https://img.shields.io/github/forks/cybozu/LicenseChecker)](https://github.com/cybozu/LicenseChecker/network/members)
[![Github stars](https://img.shields.io/github/stars/cybozu/LicenseChecker)](https://github.com/cybozu/LicenseChecker/stargazers)
[![Top language](https://img.shields.io/github/languages/top/cybozu/LicenseChecker)](https://github.com/cybozu/LicenseChecker/)
[![Release](https://img.shields.io/github/v/release/cybozu/LicenseChecker)]()
[![Github license](https://img.shields.io/github/license/cybozu/LicenseChecker)](https://github.com/cybozu/LicenseChecker/)

**Execution Example**

```shell
$ license-checker --source-packages-path ~/SourcePackages --white-list-path ~/white-list.json 
✔︎ abseil               Apache
✔︎ BoringSSL-GRPC       BoringSSL
✔︎ Firebase             Apache
✔︎ GoogleAppMeasurement Apache
✔︎ GoogleDataTransport  Apache
✔︎ GoogleUtilities      MIT
✔︎ gRPC                 Apache
✔︎ GTMSessionFetcher    Apache
✔︎ Kanna                MIT
✔︎ KeychainAccess       MIT
✔︎ Kingfisher           MIT
✔︎ leveldb              BSD
✔︎ LicenseList          MIT
✔︎ nanopb               zlib
✔︎ ObjectMapper         MIT
✔︎ Promises             Apache
✔︎ R.swift.Library      MIT
✔︎ Reachability         MIT
✔︎ RxGesture            MIT
✔︎ RxSwift              MIT
✔︎ SwiftProtobuf        Apache
✅ No problems with library licensing.
$
```

## Requirements

- Written in Swift 5
- Compatible with macOS 12.0+
- Development with Xcode 14.0+

## How to Use

0. Prepare a white list (`white-list.json`).

- Specify the type of license to approve.
- Specify the name of library to approve (for private libraries).

LicenseChecker supports the following licenses:

|license type|white list key|
|:---|:---|
|Apache license 2.0|`Apache`|
|MIT License|`MIT`|
|BSD 3-clause Clear license|`BSD`|
|zLib License|`zlib`|
|BoringSSL|`BoringSSL`|

**Sample of `white-list.json`**

```json
{
  "licenses": [
    "Apache", 
    "MIT", 
    "BSD",  
    "zlib",
    "BoringSSL"
  ],
  "libraries": [
    "PrivateLibrary-Hoge"
  ]
}
```

### CommandPlugin & Run Script in BuildPhases (for Xcode Project)

1. Add binary target & plugin to `Package.swift`.

   ```swift
   targets: [
       .binaryTarget(
           name: "license-checker",
           url: "https://github.com/cybozu/LicenseChecker/releases/download/1.1.0/license-checker-macos.artifactbundle.zip",
           checksum: "6df0b847c135f0093bf1acb4cb7072f665996b4e486ebdf26cb987b00835cd4e"
       ),
       .plugin(
           name: "LicenseCheckerCommand",
           capability: .command(
               intent: .custom(verb: "license-checker", description: "Run LicenseChecker"),
               permissions: []
           ),
           dependencies: ["license-checker"]
       )
   ]
   ```

2. Code `Plugins/LicenseCheckerCommand/main.swift`.

   ```swift
   import Foundation
   import PackagePlugin
   
   @main
   struct LicenseCheckerCommand: CommandPlugin {
       func performCommand(context: PluginContext, arguments: [String]) async throws {
           let licenseCheckerPath = try context.tool(named: "license-checker").path.string
           let rswiftURL = URL(fileURLWithPath: licenseCheckerPath, isDirectory: false)
   
           let process = try Process.run(rswiftURL, arguments: arguments)
           process.waitUntilExit()
   
           if process.terminationReason != .exit || process.terminationStatus != 0 {
               Diagnostics.error("license-checker errors detected.")
           }
       }
   }
   ```

3. Add a Run Script in BuildPhases

   ```shell
   SOURCE_PACKAGES_PATH=`echo ${BUILD_DIR%Build/*}SourcePackages`
   xcrun --sdk macosx swift package --package-path ./RoadWarriorPackages \
   --allow-writing-to-directory ${SRCROOT} \
   license-checker -s ${SOURCE_PACKAGES_PATH} -w [Path to white-list.json]
   ```

### BuildToolPlugin (for Swift Package Project)

1. Add binary target & plugin to `Package.swift`.

   ```swift
   targets: [
       .binaryTarget(
           name: "license-checker",
           url: "https://github.com/cybozu/LicenseChecker/releases/download/1.1.0/license-checker-macos.artifactbundle.zip",
           checksum: "6df0b847c135f0093bf1acb4cb7072f665996b4e486ebdf26cb987b00835cd4e"
       ),
       .plugin(
           name: "LicenseCheckerPlugin",
           capability: .buildTool(),
           dependencies: [
               .target(name: "license-checker")
           ]
       )
   ]
   ```

2. Code `Plugins/LicenseCheckerPlugin/main.swift`.

   ```swift
   import Foundation
   import PackagePlugin
   
   @main
   struct LicenseCheckerPlugin: BuildToolPlugin {
       enum LCError: Error {
           case sourcePackagesNotFound
       }
   
       func sourcePackages(_ pluginWorkDirectory: Path) throws -> Path {
           var tmpPath = pluginWorkDirectory
           guard pluginWorkDirectory.string.contains("SourcePackages") else {
               throw LCError.sourcePackagesNotFound
           }
           while tmpPath.lastComponent != "SourcePackages" {
               tmpPath = tmpPath.removingLastComponent()
           }
           return tmpPath
       }
   
       func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
           let executablePath = try context.tool(named: "license-checker").path
           let sourcePackagesPath = try sourcePackages(context.pluginWorkDirectory)
           let whiteListPath = "Path to white-list.json" // Please change accordingly.
   
           return [
               .prebuildCommand(
                   displayName: "Prepare LicenseList",
                   executable: executablePath,
                   arguments: [
                       "--source-packages-path",
                       sourcePackagesPath.string,
                       "--white-list-path",
                       whiteListPath
                   ],
                   outputFilesDirectory: context.pluginWorkDirectory
               )
           ]
       }
   }
   ```

3. Use plugin in the target (`Package.swift`).

   ```swift
   targets: [
       .target(
           name: "SomeFeature",
           resources: [.process("white-list.json")], // Please change accordingly.
           plugins: [
               .plugin(name: "LicenseCheckerPlugin")
           ]
       )
   ]
   ```

## license-checker (command help)

```shell
$ swift run license-checker -h
Building for debugging...
Build complete! (0.10s)
OVERVIEW: A tool to check license of swift package libraries.

USAGE: license-checker --source-packages-path <source-packages-path> --white-list-path <white-list-path>

OPTIONS:
  -s, --source-packages-path <source-packages-path>
                          Path to SourcePackages directory
  -w, --white-list-path <white-list-path>
                          Path to white-list.json
  --version               Show the version.
  -h, --help              Show help information.
```
