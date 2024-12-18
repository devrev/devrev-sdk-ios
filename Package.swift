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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.0.0/DevRevSDK.xcframework.zip",
            checksum: "e7a1b3defcf3211162e53cd100ab4ccab8f16f00423c9f94c289f9bcbca21832"
        )
    ]
)
