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
            checksum: "3281fccefe7a091dc39d2763ef38efa32bb9ca49fdb07902ff75163f3aeed29c"
        )
    ]
)
