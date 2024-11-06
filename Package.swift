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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.0.0-beta.3/DevRevSDK.xcframework.zip",
            checksum: "7443415f681b7f0c7277613a684d1148ccfec4bb786b1f2a5a1b27e9878bd0e4"
        )
    ]
)
