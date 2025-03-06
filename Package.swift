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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.1.2/DevRevSDK.xcframework.zip",
            checksum: "53381d4c965b14a7b37a0a77cf3647bac3a97bfd7f1e8921406a1f4d294cec31"
        )
    ]
)
