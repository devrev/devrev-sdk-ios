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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.2.0/DevRevSDK.xcframework.zip",
            checksum: "5815085578a6c2a24b5018ca9eeb94c0b0679a2cea8b7e23f4a940956738c0ae"
        )
    ]
)
