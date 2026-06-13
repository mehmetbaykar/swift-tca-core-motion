import ComposableArchitecture
import CoreMotion
import Foundation

/// A wrapper around Core Motion's `CMMotionManager` that exposes its functionality through
/// async operations and streams, making it easy to use with the Composable Architecture and easy
/// to test.
@available(iOS 4.0, *)
@available(macCatalyst 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 2.0, *)
public struct MotionManager: Sendable {
  /// The latest sample of accelerometer data.
  public func accelerometerData(id: AnyHashable) -> AccelerometerData? {
    self.accelerometerData(id)
  }

  /// Returns either the reference frame currently being used or the default attitude reference
  /// frame.
  public func attitudeReferenceFrame(id: AnyHashable) -> CMAttitudeReferenceFrame {
    self.attitudeReferenceFrame(id)
  }

  /// Creates a motion manager.
  ///
  /// A motion manager must be first created before you can use its functionality, such as starting
  /// device motion updates or accessing data directly from the manager.
  public func create(id: AnyHashable) async {
    await self.create(id)
  }

  /// Destroys a currently running motion manager.
  ///
  /// In is good practice to destroy a motion manager once you are done with it, such as when you
  /// leave a screen or no longer need motion data.
  public func destroy(id: AnyHashable) async {
    await self.destroy(id)
  }

  /// The latest sample of device-motion data.
  public func deviceMotion(id: AnyHashable) -> DeviceMotion? {
    self.deviceMotion(id)
  }

  /// The latest sample of gyroscope data.
  public func gyroData(id: AnyHashable) -> GyroData? {
    self.gyroData(id)
  }

  /// A Boolean value that indicates whether accelerometer updates are currently happening.
  public func isAccelerometerActive(id: AnyHashable) -> Bool {
    self.isAccelerometerActive(id)
  }

  /// A Boolean value that indicates whether an accelerometer is available on the device.
  public func isAccelerometerAvailable(id: AnyHashable) -> Bool {
    self.isAccelerometerAvailable(id)
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

  /// A Boolean value that determines whether gyroscope updates are currently happening.
  public func isGyroActive(id: AnyHashable) -> Bool {
    self.isGyroActive(id)
  }

  /// A Boolean value that indicates whether a gyroscope is available on the device.
  public func isGyroAvailable(id: AnyHashable) -> Bool {
    self.isGyroAvailable(id)
  }

  /// A Boolean value that determines whether magnetometer updates are currently happening.
  public func isMagnetometerActive(id: AnyHashable) -> Bool {
    self.isMagnetometerActive(id)
  }

  /// A Boolean value that indicates whether a magnetometer is available on the device.
  public func isMagnetometerAvailable(id: AnyHashable) -> Bool {
    self.isMagnetometerAvailable(id)
  }

  /// The latest sample of magnetometer data.
  public func magnetometerData(id: AnyHashable) -> MagnetometerData? {
    self.magnetometerData(id)
  }

  /// Sets certain properties on the motion manager.
  public func set(
    id: AnyHashable,
    accelerometerUpdateInterval: TimeInterval? = nil,
    deviceMotionUpdateInterval: TimeInterval? = nil,
    gyroUpdateInterval: TimeInterval? = nil,
    magnetometerUpdateInterval: TimeInterval? = nil,
    showsDeviceMovementDisplay: Bool? = nil
  ) async {
    await self.set(
      id,
      .init(
        accelerometerUpdateInterval: accelerometerUpdateInterval,
        deviceMotionUpdateInterval: deviceMotionUpdateInterval,
        gyroUpdateInterval: gyroUpdateInterval,
        magnetometerUpdateInterval: magnetometerUpdateInterval,
        showsDeviceMovementDisplay: showsDeviceMovementDisplay
      )
    )
  }

  /// Starts accelerometer updates without a handler.
  ///
  /// Returns a long-living effect that emits accelerometer data each time the motion manager
  /// receives a new value.
  public func startAccelerometerUpdates(
    id: AnyHashable,
    to queue: OperationQueue = .main
  ) -> AsyncThrowingStream<AccelerometerData, any Error> {
    self.startAccelerometerUpdates(id, queue)
  }

  /// Starts device-motion updates without a block handler.
  ///
  /// Returns a long-living effect that emits device motion data each time the motion manager
  /// receives a new value.
  public func startDeviceMotionUpdates(
    id: AnyHashable,
    using referenceFrame: CMAttitudeReferenceFrame,
    to queue: OperationQueue = .main
  ) -> AsyncThrowingStream<DeviceMotion, any Error> {
    self.startDeviceMotionUpdates(id, referenceFrame, queue)
  }

  /// Starts gyroscope updates without a handler.
  ///
  /// Returns a long-living effect that emits gyro data each time the motion manager receives a
  /// new value.
  public func startGyroUpdates(
    id: AnyHashable,
    to queue: OperationQueue = .main
  ) -> AsyncThrowingStream<GyroData, any Error> {
    self.startGyroUpdates(id, queue)
  }

  /// Starts magnetometer updates without a block handler.
  ///
  /// Returns a long-living effect that emits magnetometer data each time the motion manager
  /// receives a new value.
  public func startMagnetometerUpdates(
    id: AnyHashable,
    to queue: OperationQueue = .main
  ) -> AsyncThrowingStream<MagnetometerData, any Error> {
    self.startMagnetometerUpdates(id, queue)
  }

  /// Stops accelerometer updates.
  public func stopAccelerometerUpdates(id: AnyHashable) async {
    await self.stopAccelerometerUpdates(id)
  }

  /// Stops device-motion updates.
  public func stopDeviceMotionUpdates(id: AnyHashable) async {
    await self.stopDeviceMotionUpdates(id)
  }

  /// Stops gyroscope updates.
  public func stopGyroUpdates(id: AnyHashable) async {
    await self.stopGyroUpdates(id)
  }

  /// Stops magnetometer updates.
  public func stopMagnetometerUpdates(id: AnyHashable) async {
    await self.stopMagnetometerUpdates(id)
  }

  public init(
    accelerometerData: @escaping @Sendable (AnyHashable) -> AccelerometerData?,
    attitudeReferenceFrame: @escaping @Sendable (AnyHashable) -> CMAttitudeReferenceFrame,
    availableAttitudeReferenceFrames: @escaping @Sendable () -> CMAttitudeReferenceFrame,
    create: @escaping @Sendable (AnyHashable) async -> Void,
    destroy: @escaping @Sendable (AnyHashable) async -> Void,
    deviceMotion: @escaping @Sendable (AnyHashable) -> DeviceMotion?,
    gyroData: @escaping @Sendable (AnyHashable) -> GyroData?,
    isAccelerometerActive: @escaping @Sendable (AnyHashable) -> Bool,
    isAccelerometerAvailable: @escaping @Sendable (AnyHashable) -> Bool,
    isDeviceMotionActive: @escaping @Sendable (AnyHashable) -> Bool,
    isDeviceMotionAvailable: @escaping @Sendable (AnyHashable) -> Bool,
    isGyroActive: @escaping @Sendable (AnyHashable) -> Bool,
    isGyroAvailable: @escaping @Sendable (AnyHashable) -> Bool,
    isMagnetometerActive: @escaping @Sendable (AnyHashable) -> Bool,
    isMagnetometerAvailable: @escaping @Sendable (AnyHashable) -> Bool,
    magnetometerData: @escaping @Sendable (AnyHashable) -> MagnetometerData?,
    set: @escaping @Sendable (AnyHashable, Properties) async -> Void,
    startAccelerometerUpdates:
      @escaping @Sendable (AnyHashable, OperationQueue) ->
      AsyncThrowingStream<AccelerometerData, any Error>,
    startDeviceMotionUpdates:
      @escaping @Sendable (
        AnyHashable,
        CMAttitudeReferenceFrame,
        OperationQueue
      ) -> AsyncThrowingStream<DeviceMotion, any Error>,
    startGyroUpdates:
      @escaping @Sendable (AnyHashable, OperationQueue) ->
      AsyncThrowingStream<GyroData, any Error>,
    startMagnetometerUpdates:
      @escaping @Sendable (AnyHashable, OperationQueue) ->
      AsyncThrowingStream<MagnetometerData, any Error>,
    stopAccelerometerUpdates: @escaping @Sendable (AnyHashable) async -> Void,
    stopDeviceMotionUpdates: @escaping @Sendable (AnyHashable) async -> Void,
    stopGyroUpdates: @escaping @Sendable (AnyHashable) async -> Void,
    stopMagnetometerUpdates: @escaping @Sendable (AnyHashable) async -> Void
  ) {
    self.accelerometerData = accelerometerData
    self.attitudeReferenceFrame = attitudeReferenceFrame
    self.availableAttitudeReferenceFrames = availableAttitudeReferenceFrames
    self.create = create
    self.destroy = destroy
    self.deviceMotion = deviceMotion
    self.gyroData = gyroData
    self.isAccelerometerActive = isAccelerometerActive
    self.isAccelerometerAvailable = isAccelerometerAvailable
    self.isDeviceMotionActive = isDeviceMotionActive
    self.isDeviceMotionAvailable = isDeviceMotionAvailable
    self.isGyroActive = isGyroActive
    self.isGyroAvailable = isGyroAvailable
    self.isMagnetometerActive = isMagnetometerActive
    self.isMagnetometerAvailable = isMagnetometerAvailable
    self.magnetometerData = magnetometerData
    self.set = set
    self.startAccelerometerUpdates = startAccelerometerUpdates
    self.startDeviceMotionUpdates = startDeviceMotionUpdates
    self.startGyroUpdates = startGyroUpdates
    self.startMagnetometerUpdates = startMagnetometerUpdates
    self.stopAccelerometerUpdates = stopAccelerometerUpdates
    self.stopDeviceMotionUpdates = stopDeviceMotionUpdates
    self.stopGyroUpdates = stopGyroUpdates
    self.stopMagnetometerUpdates = stopMagnetometerUpdates
  }

  public struct Properties: Sendable {
    public var accelerometerUpdateInterval: TimeInterval?
    public var deviceMotionUpdateInterval: TimeInterval?
    public var gyroUpdateInterval: TimeInterval?
    public var magnetometerUpdateInterval: TimeInterval?
    public var showsDeviceMovementDisplay: Bool?

    public init(
      accelerometerUpdateInterval: TimeInterval? = nil,
      deviceMotionUpdateInterval: TimeInterval? = nil,
      gyroUpdateInterval: TimeInterval? = nil,
      magnetometerUpdateInterval: TimeInterval? = nil,
      showsDeviceMovementDisplay: Bool? = nil
    ) {
      self.accelerometerUpdateInterval = accelerometerUpdateInterval
      self.deviceMotionUpdateInterval = deviceMotionUpdateInterval
      self.gyroUpdateInterval = gyroUpdateInterval
      self.magnetometerUpdateInterval = magnetometerUpdateInterval
      self.showsDeviceMovementDisplay = showsDeviceMovementDisplay
    }
  }

  var accelerometerData: @Sendable (AnyHashable) -> AccelerometerData?
  var attitudeReferenceFrame: @Sendable (AnyHashable) -> CMAttitudeReferenceFrame
  /// Returns a bitmask specifying the available attitude reference frames on the device.
  var availableAttitudeReferenceFrames: @Sendable () -> CMAttitudeReferenceFrame
  var create: @Sendable (AnyHashable) async -> Void
  var destroy: @Sendable (AnyHashable) async -> Void
  var deviceMotion: @Sendable (AnyHashable) -> DeviceMotion?
  var gyroData: @Sendable (AnyHashable) -> GyroData?
  var isAccelerometerActive: @Sendable (AnyHashable) -> Bool
  var isAccelerometerAvailable: @Sendable (AnyHashable) -> Bool
  var isDeviceMotionActive: @Sendable (AnyHashable) -> Bool
  var isDeviceMotionAvailable: @Sendable (AnyHashable) -> Bool
  var isGyroActive: @Sendable (AnyHashable) -> Bool
  var isGyroAvailable: @Sendable (AnyHashable) -> Bool
  var isMagnetometerActive: @Sendable (AnyHashable) -> Bool
  var isMagnetometerAvailable: @Sendable (AnyHashable) -> Bool
  var magnetometerData: @Sendable (AnyHashable) -> MagnetometerData?
  var set: @Sendable (AnyHashable, Properties) async -> Void
  var startAccelerometerUpdates:
    @Sendable (AnyHashable, OperationQueue) -> AsyncThrowingStream<AccelerometerData, any Error>
  var startDeviceMotionUpdates:
    @Sendable (AnyHashable, CMAttitudeReferenceFrame, OperationQueue) ->
      AsyncThrowingStream<DeviceMotion, any Error>
  var startGyroUpdates:
    @Sendable (AnyHashable, OperationQueue) -> AsyncThrowingStream<GyroData, any Error>
  var startMagnetometerUpdates:
    @Sendable (AnyHashable, OperationQueue) -> AsyncThrowingStream<MagnetometerData, any Error>
  var stopAccelerometerUpdates: @Sendable (AnyHashable) async -> Void
  var stopDeviceMotionUpdates: @Sendable (AnyHashable) async -> Void
  var stopGyroUpdates: @Sendable (AnyHashable) async -> Void
  var stopMagnetometerUpdates: @Sendable (AnyHashable) async -> Void
}

#if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
  @available(iOS 4.0, *)
  @available(macCatalyst 13.0, *)
  @available(macOS, unavailable)
  @available(tvOS, unavailable)
  @available(watchOS 2.0, *)
  extension MotionManager: DependencyKey {
    public static var liveValue: Self { .live }
    public static var testValue: Self { .unimplemented() }
  }

  @available(iOS 4.0, *)
  @available(macCatalyst 13.0, *)
  @available(macOS, unavailable)
  @available(tvOS, unavailable)
  @available(watchOS 2.0, *)
  extension DependencyValues {
    public var motionManager: MotionManager {
      get { self[MotionManager.self] }
      set { self[MotionManager.self] = newValue }
    }
  }
#endif
