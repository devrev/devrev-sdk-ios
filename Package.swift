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
            checksum: "8a779888f8ac05d62ec00c17d2f20c1e21ce46f63d6813a3a1d9eadb1164da7d"
        )
    ]
)
