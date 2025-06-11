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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.0.0/DevRevSDK.xcframework.zip",
            checksum: "710077c7bbe519e73e7d514dfa2a75c7398914ec1a21e5eddd6c075a2c7478be"
        )
    ]
)
