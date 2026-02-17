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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.2.10/DevRevSDK.xcframework.zip",
            checksum: "3a2c79c3784ac755e9022645898f11637453cf275f50deea00c95ca0b90b8d17"
        )
    ]
)
