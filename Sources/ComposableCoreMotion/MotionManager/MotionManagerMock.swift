import ComposableArchitecture

@available(iOS 4.0, *)
@available(macCatalyst 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 2.0, *)
extension MotionManager {
  public static func unimplemented(
    accelerometerData: @escaping @Sendable (AnyHashable) -> AccelerometerData? = { _ in
      _unimplemented("accelerometerData")
    },
    attitudeReferenceFrame: @escaping @Sendable (AnyHashable) -> CMAttitudeReferenceFrame = { _ in
      _unimplemented("attitudeReferenceFrame")
    },
    availableAttitudeReferenceFrames: @escaping @Sendable () -> CMAttitudeReferenceFrame = {
      _unimplemented("availableAttitudeReferenceFrames")
    },
    create: @escaping @Sendable (AnyHashable) async -> Void = { _ in _unimplemented("create") },
    destroy: @escaping @Sendable (AnyHashable) async -> Void = { _ in _unimplemented("destroy") },
    deviceMotion: @escaping @Sendable (AnyHashable) -> DeviceMotion? = { _ in
      _unimplemented("deviceMotion")
    },
    gyroData: @escaping @Sendable (AnyHashable) -> GyroData? = { _ in _unimplemented("gyroData") },
    isAccelerometerActive: @escaping @Sendable (AnyHashable) -> Bool = { _ in
      _unimplemented("isAccelerometerActive")
    },
    isAccelerometerAvailable: @escaping @Sendable (AnyHashable) -> Bool = { _ in
      _unimplemented("isAccelerometerAvailable")
    },
    isDeviceMotionActive: @escaping @Sendable (AnyHashable) -> Bool = { _ in
      _unimplemented("isDeviceMotionActive")
    },
    isDeviceMotionAvailable: @escaping @Sendable (AnyHashable) -> Bool = { _ in
      _unimplemented("isDeviceMotionAvailable")
    },
    isGyroActive: @escaping @Sendable (AnyHashable) -> Bool = { _ in
      _unimplemented("isGyroActive")
    },
    isGyroAvailable: @escaping @Sendable (AnyHashable) -> Bool = { _ in
      _unimplemented("isGyroAvailable")
    },
    isMagnetometerActive: @escaping @Sendable (AnyHashable) -> Bool = { _ in
      _unimplemented("isMagnetometerActive")
    },
    isMagnetometerAvailable: @escaping @Sendable (AnyHashable) -> Bool = { _ in
      _unimplemented("isMagnetometerAvailable")
    },
    magnetometerData: @escaping @Sendable (AnyHashable) -> MagnetometerData? = { _ in
      _unimplemented("magnetometerData")
    },
    set: @escaping @Sendable (AnyHashable, MotionManager.Properties) async -> Void = { _, _ in
      _unimplemented("set")
    },
    startAccelerometerUpdates:
      @escaping @Sendable (AnyHashable, OperationQueue) ->
      AsyncThrowingStream<AccelerometerData, any Error> = { _, _ in
        _unimplemented("startAccelerometerUpdates")
      },
    startDeviceMotionUpdates:
      @escaping @Sendable (
        AnyHashable,
        CMAttitudeReferenceFrame,
        OperationQueue
      ) -> AsyncThrowingStream<DeviceMotion, any Error> = { _, _, _ in
        _unimplemented("startDeviceMotionUpdates")
      },
    startGyroUpdates:
      @escaping @Sendable (AnyHashable, OperationQueue) ->
      AsyncThrowingStream<GyroData, any Error> = { _, _ in
        _unimplemented("startGyroUpdates")
      },
    startMagnetometerUpdates:
      @escaping @Sendable (AnyHashable, OperationQueue) ->
      AsyncThrowingStream<MagnetometerData, any Error> = { _, _ in
        _unimplemented("startMagnetometerUpdates")
      },
    stopAccelerometerUpdates: @escaping @Sendable (AnyHashable) async -> Void = { _ in
      _unimplemented("stopAccelerometerUpdates")
    },
    stopDeviceMotionUpdates: @escaping @Sendable (AnyHashable) async -> Void = { _ in
      _unimplemented("stopDeviceMotionUpdates")
    },
    stopGyroUpdates: @escaping @Sendable (AnyHashable) async -> Void = { _ in
      _unimplemented("stopGyroUpdates")
    },
    stopMagnetometerUpdates: @escaping @Sendable (AnyHashable) async -> Void = { _ in
      _unimplemented("stopMagnetometerUpdates")
    }
  ) -> MotionManager {
    Self(
      accelerometerData: accelerometerData,
      attitudeReferenceFrame: attitudeReferenceFrame,
      availableAttitudeReferenceFrames: availableAttitudeReferenceFrames,
      create: create,
      destroy: destroy,
      deviceMotion: deviceMotion,
      gyroData: gyroData,
      isAccelerometerActive: isAccelerometerActive,
      isAccelerometerAvailable: isAccelerometerAvailable,
      isDeviceMotionActive: isDeviceMotionActive,
      isDeviceMotionAvailable: isDeviceMotionAvailable,
      isGyroActive: isGyroActive,
      isGyroAvailable: isGyroAvailable,
      isMagnetometerActive: isMagnetometerActive,
      isMagnetometerAvailable: isMagnetometerAvailable,
      magnetometerData: magnetometerData,
      set: set,
      startAccelerometerUpdates: startAccelerometerUpdates,
      startDeviceMotionUpdates: startDeviceMotionUpdates,
      startGyroUpdates: startGyroUpdates,
      startMagnetometerUpdates: startMagnetometerUpdates,
      stopAccelerometerUpdates: stopAccelerometerUpdates,
      stopDeviceMotionUpdates: stopDeviceMotionUpdates,
      stopGyroUpdates: stopGyroUpdates,
      stopMagnetometerUpdates: stopMagnetometerUpdates
    )
  }
}
