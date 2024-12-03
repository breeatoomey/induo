// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

// import PackageDescription

// let package = Package(
//     name: "VirtualTryOn",
//     targets: [
//         // Targets are the basic building blocks of a package, defining a module or a test suite.
//         // Targets can depend on other targets in this package and products from dependencies.
//         .executableTarget(
//             name: "VirtualTryOn"),
//     ]
// )

// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "VirtualTryOn",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/fal-ai/fal-swift.git", from: "0.1.0")
    ],
    targets: [
        .executableTarget(
            name: "VirtualTryOn",
            dependencies: [
                .product(name: "FalClient", package: "fal-swift")
            ]),
    ]
)