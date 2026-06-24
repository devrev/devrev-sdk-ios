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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.3.9/DevRevSDK.xcframework.zip",
            checksum: "1e0370ed29fa81d0155cf646aa077335cb8cbc4c7ae80a65a69fc36240b2eb9d"
        )
    ]
)
