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
    .package(path: "../..")
  ]
)
