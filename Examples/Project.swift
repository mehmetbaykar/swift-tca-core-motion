import ProjectDescription

let swiftSettings: Settings = .settings(
  base: [
    "SWIFT_VERSION": "6.0"
  ]
)

let project = Project(
  name: "MotionManager",
  targets: [
    .target(
      name: "MotionManager",
      destinations: [.iPhone, .iPad],
      product: .app,
      bundleId: "co.pointfree.MotionManager",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .file(path: "MotionManager/MotionManager/Info.plist"),
      sources: ["MotionManager/MotionManager/**/*.swift"],
      resources: ["MotionManager/MotionManager/Assets.xcassets"],
      dependencies: [
        .external(name: "ComposableCoreMotion")
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
          "PRODUCT_MODULE_NAME": "MotionManagerDemo",
          "SWIFT_VERSION": "6.0",
          "TARGETED_DEVICE_FAMILY": "1,2",
        ]
      )
    ),
    .target(
      name: "MotionManagerTests",
      destinations: [.iPhone, .iPad],
      product: .unitTests,
      bundleId: "co.pointfree.MotionManagerTests",
      deploymentTargets: .iOS("17.0"),
      infoPlist: .file(path: "MotionManager/MotionManagerTests/Info.plist"),
      sources: ["MotionManager/MotionManagerTests/**/*.swift"],
      dependencies: [
        .target(name: "MotionManager")
      ],
      settings: swiftSettings
    ),
  ]
)
