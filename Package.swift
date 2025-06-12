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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.0.1/DevRevSDK.xcframework.zip",
            checksum: "9072f96ce0763ea3590e52b0e022d5aec338f69a8a54ff550f816949303f4e23"
        )
    ]
)
