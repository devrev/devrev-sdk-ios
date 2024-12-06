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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.0.0-beta.6/DevRevSDK.xcframework.zip",
            checksum: "4b5ea9d832180572e17e88777bb15c38dbbd403e5c03fe5d13f9f0f77589a7c0"
        )
    ]
)
