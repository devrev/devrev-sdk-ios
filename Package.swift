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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.2.6/DevRevSDK.xcframework.zip",
            checksum: "ed87632ba5bed563b372d2016a827f83822a8b67f6b2a5c8ad260dab23c1c941"
        )
    ]
)
