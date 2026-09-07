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
        .library(name: "Navigation", targets: ["Navigation"]),
        .library(name: "Navigation Standard Library Integration", targets: ["Navigation Standard Library Integration"]),
        .library(name: "Navigation Foundation Library Integration", targets: ["Navigation Foundation Library Integration"]),
        .library(name: "Navigation Test Support", targets: ["Navigation Test Support"]),
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
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            path: "Sources/Navigation"
        ),
        .target(
            name: "Navigation Standard Library Integration",
            dependencies: [
                .target(name: "Navigation"),
            ],
            path: "Sources/Navigation Standard Library Integration"
        ),
        .target(
            name: "Navigation Foundation Library Integration",
            dependencies: [
                .target(name: "Navigation"),
                .target(name: "Navigation Standard Library Integration"),
            ],
            path: "Sources/Navigation Foundation Library Integration"
        ),
        .target(
            name: "Navigation Test Support",
            dependencies: [
                .target(name: "Navigation"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Navigation Tests",
            dependencies: [
                .target(name: "Navigation"),
                .target(name: "Navigation Test Support"),
                .target(name: "Navigation Standard Library Integration"),
                .target(name: "Navigation Foundation Library Integration"),
            ],
            path: "Tests/Navigation Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
