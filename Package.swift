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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.1.0/DevRevSDK.xcframework.zip",
            checksum: "92e229b89a1d8da8479e226c8e9f1e570fc05693fc9ba463cc460664bbb8a96a"
        )
    ]
)
