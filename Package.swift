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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.3.0/DevRevSDK.xcframework.zip",
            checksum: "aa0430211b4521c2cf1e3e7446c3575041c60fba5d786bb58070c165dc1b4a71"
        )
    ]
)
