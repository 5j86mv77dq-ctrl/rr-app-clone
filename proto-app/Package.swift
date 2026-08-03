// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Proto",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Proto",
            path: "Sources/Proto"
        )
    ]
)
