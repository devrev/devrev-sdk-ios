// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "DevRevSDK",
    platforms: [
        .iOS(.v13)
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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.0.0-beta.2/DevRevSDK.xcframework.zip",
            checksum: "dcd7b2bfc534da8cf003b080cf32c29e72f873a8212869c3074912e323f9a6a6"
        )
    ]
)
