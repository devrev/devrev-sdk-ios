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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.0.0-beta.6/DevRevSDK.xcframework.zip",
            checksum: "551472e6f3285658a192195df2e4862a737a36443165f2dd67fb263e30338410"
        )
    ]
)
