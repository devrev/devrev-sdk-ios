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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v0.9.1/DevRevSDK.xcframework.zip", 
            checksum: "24f0fdf4f70bcdf90c235b8ecead03aff31da3dbe1ba17391f1d97a1e3dd7c5b"
        )
    ]
)
