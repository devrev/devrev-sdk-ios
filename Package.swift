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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.0.2/DevRevSDK.xcframework.zip",
            checksum: "5bddbb2ec75a9b7243e38b962c99d571d0c59cc98adcf1b82fa33854aeedf50e"
        )
    ]
)
