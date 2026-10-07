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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v3.0.7/DevRevSDK.xcframework.zip",
            checksum: "1f8aed844be8d2efc356002fb9b1d720f47ebc839dd6d5768e45fe817f29c41b"
        )
    ]
)
