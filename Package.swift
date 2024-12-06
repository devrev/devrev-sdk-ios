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
            checksum: "8c0f056de3e00f229c836cb6fb3279b20514f2f4a218b8ba31a671dd04afa2ac"
        )
    ]
)
