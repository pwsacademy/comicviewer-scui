// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "ComicViewer",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-log",
            from: "1.6.0"
        ),
        .package(
            url: "https://github.com/stackotter/swift-image-formats",
            .upToNextMinor(from: "0.3.3")
        ),
        .package(
            url: "https://github.com/moreSwift/swift-cross-ui",
            branch: "main",
        )
    ],
    targets: [
        .executableTarget(
            name: "ComicViewer",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "DefaultBackend", package: "swift-cross-ui"),
                .product(name: "ImageFormats", package: "swift-image-formats"),
                .product(name: "SwiftCrossUI", package: "swift-cross-ui"),
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self)
            ]
        ),
        .testTarget(
            name: "ComicViewerTests",
            dependencies: ["ComicViewer"]
        )
    ]
)
