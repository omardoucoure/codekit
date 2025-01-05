// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodeKit",
    platforms: [
        .macOS(.v11),
        .iOS(.v17),
        .tvOS(.v15),
        .watchOS(.v6),
        .macCatalyst(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CodeKit",
            targets: ["CodeKit"]
        ),
    ],
    dependencies: [
          .package(
              url: "git@github.com:googleads/swift-package-manager-google-mobile-ads.git",
              from: "10.7.0" // Use the desired version
          ),
      ],
    targets: [
        .target(
            name: "CodeKit",
            dependencies: [
                .product(
                    name: "GoogleMobileAds",
                    package: "swift-package-manager-google-mobile-ads"
                )
            ]
        ),
        .testTarget(
            name: "CodeKitTests",
            dependencies: ["CodeKit"]
        ),
    ]
)
