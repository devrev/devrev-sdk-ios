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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.1.7/DevRevSDK.xcframework.zip",
            checksum: "54a8d43a377f30d4dee4a84d07b0dbbafe075a0fa3fbbd7f21ff241c90552f23"
        )
    ]
)
