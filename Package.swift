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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.2.2/DevRevSDK.xcframework.zip",
            checksum: "1f6a9e94a72fca8073e5dc3ea1498655d420a24d61a5a5369b1640ad85330cfb"
        )
    ]
)
