import ComposableArchitecture

@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
extension HeadphoneMotionManager {
  public static func unimplemented(
    create: @escaping @Sendable (AnyHashable) -> AsyncStream<Action> = { _ in
      _unimplemented("create")
    },
    destroy: @escaping @Sendable (AnyHashable) async -> Void = { _ in
      _unimplemented("destroy")
    },
    deviceMotion: @escaping @Sendable (AnyHashable) -> DeviceMotion? = { _ in
      _unimplemented("deviceMotion")
    },
    isDeviceMotionActive: @escaping @Sendable (AnyHashable) -> Bool = { _ in
      _unimplemented("isDeviceMotionActive")
    },
    isDeviceMotionAvailable: @escaping @Sendable (AnyHashable) -> Bool = { _ in
      _unimplemented("isDeviceMotionAvailable")
    },
    startDeviceMotionUpdates:
      @escaping @Sendable (AnyHashable, OperationQueue) ->
      AsyncThrowingStream<DeviceMotion, any Error> = { _, _ in
        _unimplemented("startDeviceMotionUpdates")
      },
    stopDeviceMotionUpdates: @escaping @Sendable (AnyHashable) async -> Void = { _ in
      _unimplemented("stopDeviceMotionUpdates")
    }
  ) -> HeadphoneMotionManager {
    Self(
      create: create,
      destroy: destroy,
      deviceMotion: deviceMotion,
      isDeviceMotionActive: isDeviceMotionActive,
      isDeviceMotionAvailable: isDeviceMotionAvailable,
      startDeviceMotionUpdates: startDeviceMotionUpdates,
      stopDeviceMotionUpdates: stopDeviceMotionUpdates
    )
  }
}
