// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Framezilla",
    products: [
        .library(
            name: "Framezilla",
            targets: ["Framezilla"]),
    ],
    targets: [
        .target(
            name: "Framezilla",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "FramezillaTests",
            dependencies: ["Framezilla"],
            path: "Tests"),
    ]
)
