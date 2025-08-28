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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.2.1/DevRevSDK.xcframework.zip",
            checksum: "340c6aed0a695d0c3fad10d1abcdcb92f93f866422fe92a062ae1e14a0f3f7aa"
        )
    ]
)
