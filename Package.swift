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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.1.4/DevRevSDK.xcframework.zip",
            checksum: "befbaad1d751064753ebb17969254db42e78fb751fd9b4c0a101ff1fcff40644"
        )
    ]
)
