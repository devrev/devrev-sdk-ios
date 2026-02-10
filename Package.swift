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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.2.9/DevRevSDK.xcframework.zip",
            checksum: "efd3cf7df8cfd552fc58b958db6a2990897821c6aa4b68c9c16fdfd750e2d1b3"
        )
    ]
)
