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
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      .upToNextMajor(from: "1.26.0")
    ),
    .package(path: "../.."),
  ]
)
