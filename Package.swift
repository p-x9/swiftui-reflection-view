// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ReflectionView",
    products: [
        .library(
            name: "ReflectionView",
            targets: ["ReflectionView"]
        ),
    ],
    targets: [
        .target(
            name: "ReflectionView"
        ),
        .testTarget(
            name: "ReflectionViewTests",
            dependencies: ["ReflectionView"]
        ),
    ]
)
