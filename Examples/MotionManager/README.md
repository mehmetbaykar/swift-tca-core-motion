# Motion Manager Example

This Tuist app demonstrates `MotionManager` as a TCA dependency. It uses `CMMotionManager` through `ComposableCoreMotion` to stream device motion, compute vertical movement, plot samples, and update the background when the device turns away from the user.

Live motion updates require a real iPhone or iPad. The simulator can build the app and run reducer tests, but it cannot provide real Core Motion data.

Generate the workspace from the `Examples` directory:

```sh
tuist install
tuist generate
```

Open `MotionManager.xcworkspace`, select the `MotionManager` scheme, and run it on a physical device.

Useful files:

* [MotionManagerView.swift](./MotionManager/MotionManagerView.swift) contains the `@Reducer`, SwiftUI view, and preview dependency override.
* [MotionTests.swift](./MotionManagerTests/MotionTests.swift) shows Swift Testing plus `TestStore` coverage with an overridden `\.motionManager`.

From the repository root, `make test-examples` regenerates the Tuist workspace and runs the example tests on an available iOS simulator.
