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
            checksum: "3a672ae568e0d9b2db05651d2df073835f6e88284f2e0031a3ab7ead335b6123"
        )
    ]
)
