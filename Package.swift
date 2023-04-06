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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v0.9.0/DevRevSDK.xcframework.zip", 
            checksum: "45e0a67c85b50d59cf1d84441f2c7d9e0bfc00ee46cd5620747191b027b392e9"
        )
    ]
)
