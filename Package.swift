// swift-tools-version:6.1

import PackageDescription

let package = Package(
  name: "composable-core-motion",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .watchOS(.v9),
  ],
  products: [
    .library(
      name: "ComposableCoreMotion",
      targets: ["ComposableCoreMotion"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.26.0")
  ],
  targets: [
    .target(
      name: "ComposableCoreMotion",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
    .testTarget(
      name: "ComposableCoreMotionTests",
      dependencies: ["ComposableCoreMotion"]
    ),
  ],
  swiftLanguageModes: [.v6]
)
