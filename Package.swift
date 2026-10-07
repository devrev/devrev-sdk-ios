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
            checksum: "7ef9e3799157814df7f68014eb20023e876bc4a518e64fc16f60238943a86d28"
        )
    ]
)
