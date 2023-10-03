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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v0.9.2/DevRevSDK.xcframework.zip", 
            checksum: "3f28597cb0fc2ea725e67a6ae14488ab15c9574dea6fb605e633b0b8982e27cb"
        )
    ]
)
