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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.1.6/DevRevSDK.xcframework.zip",
            checksum: "0899d2d3a5a4e8b55ab1c7c917c286399bede73313a1057d4d326735bf2d1d36"
        )
    ]
)
