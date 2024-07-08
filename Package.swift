// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "DevRevSDK",
    platforms: [
        .iOS(.v13)
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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v0.9.3/DevRevSDK.xcframework.zip",
            checksum: "49e4b6daa2993b22f0d4aced7b2e115921f95bcd87ed3f7d7b330e8697c1c5cb"
        )
    ]
)
