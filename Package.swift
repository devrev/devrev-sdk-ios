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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.0.3/DevRevSDK.xcframework.zip",
            checksum: "9aac35d9bb90cd6ef32be7ef034476c7b36b32383b141237ab38d60e4a4fde51"
        )
    ]
)
