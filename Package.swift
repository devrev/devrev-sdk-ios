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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.3.5/DevRevSDK.xcframework.zip",
            checksum: "34bef882a63b679cc8216fa907d820aad0051458964ebfdad0000eb7aa3b61c3"
        )
    ]
)
