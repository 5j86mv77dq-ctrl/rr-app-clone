// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Prototype",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Prototype",
            path: "Sources/Prototype"
        )
    ]
)
