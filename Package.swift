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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.1.1/DevRevSDK.xcframework.zip",
            checksum: "549a08539cf2601ec7e73b67ae5a58979d917b3f4daa5f30ebf3e66b74315095"
        )
    ]
)
