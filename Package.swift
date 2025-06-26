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
            url: "https://github.com/devrev/devrev-sdk-ios/releases/download/v2.1.0/DevRevSDK.xcframework.zip",
            checksum: "cc6f553629b64728bd493ccd12ef21b26863d7e864e50ebe054af58a271fabee"
        )
    ]
)
