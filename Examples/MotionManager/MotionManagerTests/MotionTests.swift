import ComposableArchitecture
import ComposableCoreMotion
import CoreMotion
import Testing

@testable import MotionManagerDemo

@Suite
@MainActor
struct MotionTests {
  @Test
  func motionUpdate() async {
    let stream = AsyncThrowingStream<DeviceMotion, any Error>.makeStream(of: DeviceMotion.self)
    let motionManagerIsLive = LockIsolated(false)

    let store = TestStore(initialState: AppFeature.State()) {
      AppFeature()
    } withDependencies: {
      $0.motionManager = .unimplemented(
        create: { _ in motionManagerIsLive.setValue(true) },
        destroy: { _ in motionManagerIsLive.setValue(false) },
        deviceMotion: { _ in nil },
        startDeviceMotionUpdates: { _, _, _ in stream.stream },
        stopDeviceMotionUpdates: { _ in stream.continuation.finish() }
      )
    }

    let deviceMotion = DeviceMotion(
      attitude: .init(quaternion: .init(x: 1, y: 0, z: 0, w: 0)),
      gravity: CMAcceleration(x: 1, y: 2, z: 3),
      heading: 0,
      magneticField: .init(field: .init(x: 0, y: 0, z: 0), accuracy: .high),
      rotationRate: .init(x: 0, y: 0, z: 0),
      timestamp: 0,
      userAcceleration: CMAcceleration(x: 4, y: 5, z: 6)
    )

    await store.send(.recordingButtonTapped) {
      $0.isRecording = true
    }
    #expect(motionManagerIsLive.value == true)

    stream.continuation.yield(deviceMotion)
    await store.receive(.motionUpdate(.success(deviceMotion))) {
      $0.z = [32]
    }

    await store.send(.recordingButtonTapped) {
      $0.isRecording = false
    }
    await store.finish()
    #expect(motionManagerIsLive.value == false)
  }

  @Test
  func facingDirection() async {
    let stream = AsyncThrowingStream<DeviceMotion, any Error>.makeStream(of: DeviceMotion.self)
    let motionManagerIsLive = LockIsolated(false)

    let initialDeviceMotion = DeviceMotion(
      attitude: .init(quaternion: .init(x: 1, y: 0, z: 0, w: 0)),
      gravity: CMAcceleration(x: 0, y: 0, z: 0),
      heading: 0,
      magneticField: .init(field: .init(x: 0, y: 0, z: 0), accuracy: .high),
      rotationRate: .init(x: 0, y: 0, z: 0),
      timestamp: 0,
      userAcceleration: CMAcceleration(x: 0, y: 0, z: 0)
    )
    var updatedDeviceMotion = initialDeviceMotion
    updatedDeviceMotion.attitude = .init(quaternion: .init(x: 0, y: 0, z: 1, w: 0))

    let store = TestStore(initialState: AppFeature.State()) {
      AppFeature()
    } withDependencies: {
      $0.motionManager = .unimplemented(
        create: { _ in motionManagerIsLive.setValue(true) },
        destroy: { _ in motionManagerIsLive.setValue(false) },
        deviceMotion: { _ in initialDeviceMotion },
        startDeviceMotionUpdates: { _, _, _ in stream.stream },
        stopDeviceMotionUpdates: { _ in stream.continuation.finish() }
      )
    }

    await store.send(.recordingButtonTapped) {
      $0.isRecording = true
    }
    #expect(motionManagerIsLive.value == true)

    stream.continuation.yield(initialDeviceMotion)
    await store.receive(.motionUpdate(.success(initialDeviceMotion))) {
      $0.facingDirection = .forward
      $0.initialAttitude = initialDeviceMotion.attitude
      $0.z = [0]
    }

    stream.continuation.yield(updatedDeviceMotion)
    await store.receive(.motionUpdate(.success(updatedDeviceMotion))) {
      $0.z = [0, 0]
      $0.facingDirection = .backward
    }

    await store.send(.recordingButtonTapped) {
      $0.facingDirection = nil
      $0.initialAttitude = nil
      $0.isRecording = false
    }
    await store.finish()
    #expect(motionManagerIsLive.value == false)
  }
}
