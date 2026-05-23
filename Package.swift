// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "OneSecurity",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "OneSecurity",
            targets: ["OneSecurity"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/avgx/RequestResponse", from: "2.0.1"),
    ],
    targets: [
        .target(
            name: "OneSecurity",
            dependencies: [
                .product(name: "RequestResponse", package: "RequestResponse"),
            ]
        ),
        .testTarget(
            name: "OneSecurityTests",
            dependencies: ["OneSecurity"],
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
