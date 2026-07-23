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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v3.0.1/DevRevSDK.xcframework.zip",
            checksum: "58a407484b6ca6bcec1e2fecd676f48932033bda99e4f68b0572660969514bbb"
        )
    ]
)
