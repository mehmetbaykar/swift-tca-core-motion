// swift-tools-version: 6.3

import PackageDescription

#if TUIST
  import ProjectDescription

  let packageSettings = PackageSettings(
    productTypes: [
      "ComposableCoreMotion": .framework
    ]
  )
#endif

let package = Package(
  name: "MotionManagerDependencies",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .watchOS(.v9),
  ],
  dependencies: [
    .package(path: "../..")
  ],
  targets: [
    .target(
      name: "MotionManagerDependencies",
      dependencies: [
        .product(name: "ComposableCoreMotion", package: "swift-tca-core-motion")
      ]
    )
  ]
)
