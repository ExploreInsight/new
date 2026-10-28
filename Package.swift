// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "Snapper",
    platforms: [.macOS(.v26)],
    targets: [
        // Rules and data logic with no SwiftUI, so tests run without the app.
        .target(name: "SnapperKit"),
        .executableTarget(
            name: "Snapper",
            dependencies: ["SnapperKit"],
            // App code runs on the main thread unless you say otherwise.
            swiftSettings: [.defaultIsolation(MainActor.self)]
        ),
        .testTarget(name: "SnapperKitTests", dependencies: ["SnapperKit"]),
    ]
)
