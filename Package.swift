// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "music2go",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "music2go",
            targets: ["music2go"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
        .package(url: "https://github.com/fwcd/swift-music-library.git", from: "1.2.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Music2GoSupport",
            dependencies: [
                .product(name: "MusicLibrary", package: "swift-music-library"),
            ]
        ),
        .executableTarget(
            name: "music2go",
            dependencies: [
                .target(name: "Music2GoSupport"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "MusicLibrary", package: "swift-music-library"),
            ]
        ),
    ]
)
