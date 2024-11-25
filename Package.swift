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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v1.0.0-beta.4/DevRevSDK.xcframework.zip",
            checksum: "62525d38e0a7a639e7ea011de2dcef92f64f34dbcbf740da3aaa36c2ced7e57a"
        )
    ]
)
