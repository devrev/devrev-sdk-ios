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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.2.4/DevRevSDK.xcframework.zip",
            checksum: "56af98c7ea7c47c202188de01d2935acbed1a61fd32f1ae081902d019ad622ba"
        )
    ]
)
