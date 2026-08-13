// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "DevRevSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DevRevSDK",
            targets: [
                "DevRevSDK",
            ]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "DevRevSDK",
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v3.0.3/DevRevSDK.xcframework.zip",
            checksum: "fc4fe3fda1dded495abc1411ce14101181043a3ecd034cebc3af46a9e0bb166e"
        )
    ]
)
