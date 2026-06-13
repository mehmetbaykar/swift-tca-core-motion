import ComposableArchitecture
import CoreMotion
import Foundation

/// A wrapper around Core Motion's `CMHeadphoneMotionManager` that exposes its functionality
/// through effects and actions, making it easy to use with the Composable Architecture, and easy
/// to test.
@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
public struct HeadphoneMotionManager: Sendable {

  /// Actions that correspond to `CMHeadphoneMotionManagerDelegate` methods.
  ///
  /// See `CMHeadphoneMotionManagerDelegate` for more information.
  public enum Action: Equatable, Sendable {
    case didConnect
    case didDisconnect
  }

  /// Creates a headphone motion manager.
  ///
  /// A motion manager must be first created before you can use its functionality, such as
  /// starting device motion updates or accessing data directly from the manager.
  public func create(id: AnyHashable) -> AsyncStream<Action> {
    self.create(id)
  }

  /// Destroys a currently running headphone motion manager.
  ///
  /// In is good practice to destroy a headphone motion manager once you are done with it, such as
  /// when you leave a screen or no longer need motion data.
  public func destroy(id: AnyHashable) async {
    await self.destroy(id)
  }

  /// The latest sample of device-motion data.
  public func deviceMotion(id: AnyHashable) -> DeviceMotion? {
    self.deviceMotion(id)
  }

  /// A Boolean value that determines whether the app is receiving updates from the device-motion
  /// service.
  public func isDeviceMotionActive(id: AnyHashable) -> Bool {
    self.isDeviceMotionActive(id)
  }

  /// A Boolean value that indicates whether the device-motion service is available on the device.
  public func isDeviceMotionAvailable(id: AnyHashable) -> Bool {
    self.isDeviceMotionAvailable(id)
  }

  /// Starts device-motion updates without a block handler.
  ///
  /// Returns a long-living effect that emits device motion data each time the headphone motion
  /// manager receives a new value.
  public func startDeviceMotionUpdates(
    id: AnyHashable,
    to queue: OperationQueue = .main
  ) -> AsyncThrowingStream<DeviceMotion, any Error> {
    self.startDeviceMotionUpdates(id, queue)
  }

  /// Stops device-motion updates.
  public func stopDeviceMotionUpdates(id: AnyHashable) async {
    await self.stopDeviceMotionUpdates(id)
  }

  public init(
    create: @escaping @Sendable (AnyHashable) -> AsyncStream<Action>,
    destroy: @escaping @Sendable (AnyHashable) async -> Void,
    deviceMotion: @escaping @Sendable (AnyHashable) -> DeviceMotion?,
    isDeviceMotionActive: @escaping @Sendable (AnyHashable) -> Bool,
    isDeviceMotionAvailable: @escaping @Sendable (AnyHashable) -> Bool,
    startDeviceMotionUpdates:
      @escaping @Sendable (AnyHashable, OperationQueue) ->
      AsyncThrowingStream<DeviceMotion, any Error>,
    stopDeviceMotionUpdates: @escaping @Sendable (AnyHashable) async -> Void
  ) {
    self.create = create
    self.destroy = destroy
    self.deviceMotion = deviceMotion
    self.isDeviceMotionActive = isDeviceMotionActive
    self.isDeviceMotionAvailable = isDeviceMotionAvailable
    self.startDeviceMotionUpdates = startDeviceMotionUpdates
    self.stopDeviceMotionUpdates = stopDeviceMotionUpdates
  }

  var create: @Sendable (AnyHashable) -> AsyncStream<Action>
  var destroy: @Sendable (AnyHashable) async -> Void
  var deviceMotion: @Sendable (AnyHashable) -> DeviceMotion?
  var isDeviceMotionActive: @Sendable (AnyHashable) -> Bool
  var isDeviceMotionAvailable: @Sendable (AnyHashable) -> Bool
  var startDeviceMotionUpdates:
    @Sendable (AnyHashable, OperationQueue) -> AsyncThrowingStream<DeviceMotion, any Error>
  var stopDeviceMotionUpdates: @Sendable (AnyHashable) async -> Void
}

#if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
  @available(iOS 14, *)
  @available(macCatalyst 14, *)
  @available(macOS, unavailable)
  @available(tvOS, unavailable)
  @available(watchOS 7, *)
  extension HeadphoneMotionManager: DependencyKey {
    public static var liveValue: Self { .live }
    public static var testValue: Self { .unimplemented() }
  }

  @available(iOS 14, *)
  @available(macCatalyst 14, *)
  @available(macOS, unavailable)
  @available(tvOS, unavailable)
  @available(watchOS 7, *)
  extension DependencyValues {
    public var headphoneMotionManager: HeadphoneMotionManager {
      get { self[HeadphoneMotionManager.self] }
      set { self[HeadphoneMotionManager.self] = newValue }
    }
  }
#endif
