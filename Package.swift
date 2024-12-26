// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "LicenseChecker",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "license-checker",
            targets: ["license-checker"]
        ),
        .plugin(
            name: "LicenseCheckerPlugin",
            targets: ["LicenseCheckerPlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0")
    ],
    targets: [
        .target(name: "LicenseCheckerModule"),
        .executableTarget(
            name: "license-checker",
            dependencies: [
                .target(name: "LicenseCheckerModule"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")
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
                .target(name: "license-checker"),
                .target(name: "TestResources")
            ]
        ),
        .plugin(
            name: "LicenseCheckerPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "license-checker")
            ]
        )
    ]
)
