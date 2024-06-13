// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "LicenseChecker",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "license-checker",
            targets: ["LicenseChecker"]
        ),
        .plugin(
            name: "LicenseCheckerPlugin",
            targets: ["LicenseCheckerPlugin"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            exact: "1.1.3"
        )
    ],
    targets: [
        .target(name: "LicenseCheckerModule"),
        .executableTarget(
            name: "LicenseChecker",
            dependencies: [
                .target(name: "LicenseCheckerModule"),
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ]
        ),
        .target(
            name: "TestResources",
            resources: [.copy("Resources/")]
        ),
        .testTarget(
            name: "LicenseCheckerModuleTests",
            dependencies: [
                .target(name: "LicenseCheckerModule"),
                .target(name: "TestResources")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "LicenseCheckerTests",
            dependencies: [
                .target(name: "LicenseChecker"),
                .target(name: "TestResources")
            ]
        ),
        .plugin(
            name: "LicenseCheckerPlugin",
            capability: .buildTool(),
            dependencies: ["LicenseChecker"]
        )
    ]
)
