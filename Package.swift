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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.0.1/DevRevSDK.xcframework.zip",
            checksum: "3bfda0f2baf6e1ed7b18511cc31845ae40bb09e4366379fbf3db467025bc283c"
        )
    ]
)
