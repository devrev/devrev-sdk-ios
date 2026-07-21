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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v3.0.0/DevRevSDK.xcframework.zip",
            checksum: "a6a9f77b17896fb64045c408cdca61d3bc5dfff7470b7d0971b38afa45dd5abc"
        )
    ]
)
