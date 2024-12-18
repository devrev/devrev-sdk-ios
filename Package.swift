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
            checksum: "a50a7d2aa1219f8c541736b5ff9cdd76aba25f333eebcd47e56b0dd68868ae5f"
        )
    ]
)
