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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v3.0.2/DevRevSDK.xcframework.zip",
            checksum: "bf8995d9061f10493a7bf0de90a542165b24097c6f8c6e75c6256a68b11e8056"
        )
    ]
)
