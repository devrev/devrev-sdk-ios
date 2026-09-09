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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v3.0.5/DevRevSDK.xcframework.zip",
            checksum: "7b249a480c3654dfa786d37f1f784857e511088c71f508ac8148fa58bb59d1d0"
        )
    ]
)
