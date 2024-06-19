// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "HelloServer",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "HelloServer",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio")
            ]
        ),
    ]
)