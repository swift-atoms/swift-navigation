// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-navigation",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        ),
        .library(
            name: "Navigation Standard Library Integration",
            targets: ["Navigation Standard Library Integration"]
        ),
        .library(
            name: "Navigation Apple Foundation Integration",
            targets: ["Navigation Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "Navigation",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged")
            ]
        ),
        .target(
            name: "Navigation Standard Library Integration",
            dependencies: ["Navigation"]
        ),
        .target(
            name: "Navigation Apple Foundation Integration",
            dependencies: [
                "Navigation",
                "Navigation Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Navigation Tests",
            dependencies: [
                "Navigation"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
