// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ReflectionView",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "ReflectionView",
            targets: ["ReflectionView"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/p-x9/SwiftUIColor.git", from: "0.4.0"),
        .package(url: "https://github.com/p-x9/swift-magic-mirror.git", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "Reflection",
            dependencies: [
                .product(name: "MagicMirror", package: "swift-magic-mirror")
            ]
        ),
        .target(
            name: "ReflectionView",
            dependencies: [
                "Reflection",
                .product(name: "SwiftUIColor", package: "SwiftUIColor"),
                .product(name: "MagicMirror", package: "swift-magic-mirror")
            ],
            resources: [
                .process("Assets")
            ]
        ),
        .testTarget(
            name: "ReflectionViewTests",
            dependencies: [
                "Reflection",
                "ReflectionView"
            ]
        ),
    ]
)
