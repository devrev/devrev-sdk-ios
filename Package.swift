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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.1.5/DevRevSDK.xcframework.zip",
            checksum: "34ba2602d4ef20cd22e59b02ebd382699aed72d102cf189e4d2b3749fa31cb9b"
        )
    ]
)
