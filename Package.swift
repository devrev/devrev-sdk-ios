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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.0.0-beta.4/DevRevSDK.xcframework.zip",
            checksum: "8e823a48d08b2279975adfe2c4b5b8d7d19bd99083d1ff161c3f4c4cb326b917"
        )
    ]
)
