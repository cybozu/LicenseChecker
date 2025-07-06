# LicenseChecker

LicenseChecker is a command line tool checking licenses of swift package libraries that your app depends on.  
It can detect libraries that are not included in a whitelist specifying the license type or library name.

[![Github forks](https://img.shields.io/github/forks/cybozu/LicenseChecker)](https://github.com/cybozu/LicenseChecker/network/members)
[![Github stars](https://img.shields.io/github/stars/cybozu/LicenseChecker)](https://github.com/cybozu/LicenseChecker/stargazers)
[![Github issues](https://img.shields.io/github/issues/cybozu/LicenseChecker)](https://github.com/cybozu/LicenseChecker/issues)
[![Github release](https://img.shields.io/github/v/release/cybozu/LicenseChecker)](https://github.com/cybozu/LicenseChecker/release)
[![Github license](https://img.shields.io/github/license/cybozu/LicenseChecker)](https://github.com/cybozu/LicenseChecker/blob/main/LICENSE)

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

- Development with Xcode 16.4+
- Written in Swift 6.1
- Compatible with macOS 14.0+

## How to Use

0. Prepare a white list (`white-list.json`).

- Specify the type of license to approve.
- Specify the name of library to approve (for private libraries).

LicenseChecker supports the following licenses:

| license type               | white list key |
| :------------------------- | :------------- |
| Apache license 2.0         | `Apache`       |
| MIT License                | `MIT`          |
| BSD 3-clause Clear license | `BSD`          |
| zLib License               | `zlib`         |
| BoringSSL                  | `BoringSSL`    |

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

### XcodeBuildToolPlugin (for Xcode Project)

1. Put `white-list.json` to the project root (`white-list.json` is in the same location as `xcodeproj`).
2. File > Add Package Dependencies…  
   <img src="Screenshots/add-package-dependencies.png" width="800px">
3. Search `https://github.com/cybozu/LicenseChecker.git.`  
   <img src="Screenshots/add-package.png" width="600px">
4. Use plugin in Build Phases.  
   <img src="Screenshots/add-plugin.png" width="500px">

### BuildToolPlugin (for Swift Package Project)

1. Put `white-list.json` to the package root (`white-list.json` is in the same location as `Package.swift`).

2. Add the dependency of plugin to `Package.swift`.

   ```swift
   dependencies: [
       .package(url: "https://github.com/cybozu/LicenseChecker.git", exact: "2.2.1")
   ],
   ```

3. Use plugin in the target (`Package.swift`).

   ```swift
   targets: [
       .target(
           name: "SomeFeature",
           plugins: [
               .plugin(name: "LicenseCheckerPlugin", package: "LicenseChecker")
           ]
       )
   ]
   ```

### CommandPlugin & Run Script in BuildPhases (for Xcode Project)

If your project directory structure is special and you want to specify the path to white-list.json, use CommandPlugin.

1. Add binary target & plugin to `Package.swift`.

   ```swift
   targets: [
       .binaryTarget(
           name: "license-checker",
           url: "https://github.com/cybozu/LicenseChecker/releases/download/2.1.0/license-checker-macos.artifactbundle.zip",
           checksum: "e11383d96a492599f3b6cd961899508c5c4bc3224353213c51aeb169f5f3e6a9"
       ),
       .plugin(
           name: "LicenseCheckerPlugin",
           capability: .command(
               intent: .custom(verb: "license-checker", description: "Check Licenses."),
               permissions: []
           ),
           dependencies: ["license-checker"]
       )
   ]
   ```

2. Code `Plugins/LicenseCheckerPlugin/main.swift`.

   ```swift
   import Foundation
   import PackagePlugin

   @main
   struct LicenseCheckerPlugin: CommandPlugin {
       func performCommand(context: PluginContext, arguments: [String]) async throws {
           let tool = try context.tool(named: "license-checker")

           let process = try Process.run(tool.url, arguments: arguments)
           process.waitUntilExit()

           guard process.terminationReason == .exit else {
               Diagnostics.error("Termination Other Than Exit")
               return
           }
           guard process.terminationStatus == EXIT_SUCCESS else {
               Diagnostics.error("Command Failed")
               return
           }
       }
   }
   ```

3. Add a Run Script in BuildPhases.

   ```shell
   SOURCE_PACKAGES_PATH=`echo ${BUILD_DIR%Build/*}SourcePackages`
   xcrun --sdk macosx \
     swift package --package-path ./PluginPackages plugin --allow-writing-to-directory . \
     license-checker -s ${SOURCE_PACKAGES_PATH} -w [Path to white-list.json]
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
