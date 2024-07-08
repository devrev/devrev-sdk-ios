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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v0.9.3/DevRevSDK.xcframework.zip",
            checksum: "de0156d7dfb3d3f52ce3be05738f8653548b85a2c33959c46fdcebfe2543825f"
        )
    ]
)
