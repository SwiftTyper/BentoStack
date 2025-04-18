// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BentoStack",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .visionOS(.v1),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "BentoStack",
            targets: ["BentoStack"]),
    ],
    targets: [
        .target(
            name: "BentoStack"),
        .testTarget(
            name: "BentoStackTests",
            dependencies: ["BentoStack"]
        ),
    ]
)
