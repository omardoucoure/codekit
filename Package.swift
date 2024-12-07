// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodeKit",
    platforms: [.macOS(.v11), .iOS(.v16), .tvOS(.v15), .watchOS(.v6), .macCatalyst(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CodeKit",
            targets: ["CodeKit"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CodeKit"),
        .testTarget(
            name: "CodeKitTests",
            dependencies: ["CodeKit"]
        ),
    ]
)
