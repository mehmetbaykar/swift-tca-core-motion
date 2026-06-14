# Composable Core Motion

[![CI](https://github.com/mehmetbaykar/swift-tca-core-motion/actions/workflows/ci.yml/badge.svg)](https://github.com/mehmetbaykar/swift-tca-core-motion/actions/workflows/ci.yml)

Composable Core Motion bridges Apple's [Core Motion](https://developer.apple.com/documentation/coremotion) APIs into [the Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture). It exposes motion managers as TCA dependencies with async operations, async streams, live implementations, and controllable test values.

* [Example](#example)
* [Requirements](#requirements)
* [Installation](#installation)
* [Basic usage](#basic-usage)
* [Testing](#testing)
* [API surface](#api-surface)
* [Documentation](#documentation)
* [Help](#help)

## Example

Check out the [MotionManager](./Examples/MotionManager) demo to see `ComposableCoreMotion` in a TCA feature. The app records device motion, graphs movement, changes background color from attitude changes, and includes Swift Testing coverage for the reducer.

The live demo needs a real iPhone, iPad, or Apple Watch for motion updates. The simulator can build the app and run tests, but it cannot provide real Core Motion samples.

## Requirements

The package currently targets Swift 6.3, TCA 1.26, and these platform minimums:

* iOS 16
* macOS 13
* watchOS 9

`MotionManager` and `HeadphoneMotionManager` mirror Core Motion availability. Their live implementations are available on iOS, watchOS, and Mac Catalyst; their manager APIs are unavailable on macOS and tvOS.

## Installation

Add this package to an Xcode project with **File > Add Package Dependencies...** and use:

```text
https://github.com/mehmetbaykar/swift-tca-core-motion
```

For SwiftPM, add the package and depend on the `ComposableCoreMotion` product:

```swift
.package(url: "https://github.com/mehmetbaykar/swift-tca-core-motion", branch: "main")
```

```swift
.product(name: "ComposableCoreMotion", package: "swift-tca-core-motion")
```

## Basic usage

`MotionManager` is registered in `DependencyValues` as `\.motionManager`. Create a manager before using it, start one of the update streams from an effect, cancel that long-living effect when recording stops, and destroy the manager when done.

```swift
import ComposableArchitecture
import ComposableCoreMotion
import CoreMotion

@Reducer
struct Feature {
  @ObservableState
  struct State: Equatable {
    var isRecording = false
    var z: [Double] = []
  }

  enum Action: Equatable {
    case motionUpdate(Result<DeviceMotion, NSError>)
    case recordingButtonTapped
  }

  @Dependency(\.motionManager) var motionManager

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .motionUpdate(.success(motion)):
        state.z.append(
          motion.gravity.x * motion.userAcceleration.x
            + motion.gravity.y * motion.userAcceleration.y
            + motion.gravity.z * motion.userAcceleration.z
        )
        return .none

      case .motionUpdate(.failure):
        state.isRecording = false
        return .run { _ in
          await motionManager.stopDeviceMotionUpdates(id: MotionManagerID())
          await motionManager.destroy(id: MotionManagerID())
        }

      case .recordingButtonTapped:
        state.isRecording.toggle()

        if state.isRecording {
          return .run { send in
            await motionManager.create(id: MotionManagerID())

            do {
              for try await motion in motionManager.startDeviceMotionUpdates(
                id: MotionManagerID(),
                using: .xArbitraryZVertical,
                to: .main
              ) {
                await send(.motionUpdate(.success(motion)))
              }
            } catch {
              await send(.motionUpdate(.failure(error as NSError)))
            }
          }
          .cancellable(id: MotionManagerID(), cancelInFlight: true)
        } else {
          return .merge(
            .cancel(id: MotionManagerID()),
            .run { _ in
              await motionManager.stopDeviceMotionUpdates(id: MotionManagerID())
              await motionManager.destroy(id: MotionManagerID())
            }
          )
        }
      }
    }
  }
}

private struct MotionManagerID: Hashable, Sendable {}
```

Use the same pattern for accelerometer, gyro, magnetometer, and headphone motion streams. Use `set(id:accelerometerUpdateInterval:deviceMotionUpdateInterval:gyroUpdateInterval:magnetometerUpdateInterval:showsDeviceMovementDisplay:)` before starting updates when you need custom sampling intervals.

## Testing

Tests should override only the endpoints used by the feature. The `.unimplemented(...)` helper traps if an unexpected endpoint is called, which keeps dependency usage explicit.

```swift
import ComposableArchitecture
import ComposableCoreMotion
import CoreMotion
import Testing

@MainActor
@Test
func startsAndStopsMotionUpdates() async {
  let stream = AsyncThrowingStream<DeviceMotion, any Error>.makeStream(of: DeviceMotion.self)
  let motionManagerIsLive = LockIsolated(false)

  let store = TestStore(initialState: Feature.State()) {
    Feature()
  } withDependencies: {
    $0.motionManager = .unimplemented(
      create: { _ in motionManagerIsLive.setValue(true) },
      destroy: { _ in motionManagerIsLive.setValue(false) },
      startDeviceMotionUpdates: { _, _, _ in stream.stream },
      stopDeviceMotionUpdates: { _ in stream.continuation.finish() }
    )
  }

  await store.send(.recordingButtonTapped) {
    $0.isRecording = true
  }
  #expect(motionManagerIsLive.value == true)

  await store.send(.recordingButtonTapped) {
    $0.isRecording = false
  }
  await store.finish()
  #expect(motionManagerIsLive.value == false)
}
```

See [MotionTests.swift](./Examples/MotionManager/MotionManagerTests/MotionTests.swift) for full reducer tests that yield `DeviceMotion` values into an `AsyncThrowingStream` and assert derived state.

## API surface

`MotionManager` wraps `CMMotionManager` and provides:

* `create(id:)` and `destroy(id:)`
* `set(id:...)` for update intervals and movement display settings
* latest accelerometer, device-motion, gyro, and magnetometer data
* availability and active-state queries
* start/stop streams for accelerometer, device motion, gyro, and magnetometer updates

`HeadphoneMotionManager` wraps `CMHeadphoneMotionManager` and provides:

* `create(id:)`, returning an `AsyncStream<HeadphoneMotionManager.Action>` for connect and disconnect delegate events
* `destroy(id:)`
* latest headphone device-motion data
* device-motion availability and active-state queries
* start/stop streams for headphone device-motion updates

Model types such as `DeviceMotion`, `Attitude`, `AccelerometerData`, `GyroData`, and `MagnetometerData` wrap Core Motion values in test-friendly Swift types.

## Documentation

API documentation is generated from `Sources/ComposableCoreMotion` by the [Documentation workflow](./.github/workflows/documentation.yml). For usage patterns, start with this README and the [MotionManager example](./Examples/MotionManager).

## Help

For questions about Composable Core Motion with TCA, use the [Swift forums TCA category](https://forums.swift.org/c/related-projects/swift-composable-architecture).

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
