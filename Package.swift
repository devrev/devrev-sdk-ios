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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.1.3/DevRevSDK.xcframework.zip",
            checksum: "51cbf3582b41dcfac134b488cfc9bb7cbc32d38c1e8a91399bb4f92ce9bb3c53"
        )
    ]
)
