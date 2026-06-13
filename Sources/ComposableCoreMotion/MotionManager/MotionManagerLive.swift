#if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
  import ComposableArchitecture
  import CoreMotion
  import Foundation

  @available(iOS 4, *)
  @available(macCatalyst 13, *)
  @available(macOS, unavailable)
  @available(tvOS, unavailable)
  @available(watchOS 2, *)
  extension MotionManager {
    public static let live = MotionManager(
      accelerometerData: { id in
        requireMotionManager(id: MotionID(id))?.value.accelerometerData.map(AccelerometerData.init)
      },
      attitudeReferenceFrame: { id in
        requireMotionManager(id: MotionID(id))?.value.attitudeReferenceFrame ?? .init()
      },
      availableAttitudeReferenceFrames: {
        CMMotionManager.availableAttitudeReferenceFrames()
      },
      create: { id in
        let id = MotionID(id)
        if motionManagers.withValue({ $0[id] != nil }) {
          assertionFailure(
            """
            You are attempting to create a motion manager with the id \(id.rawValue), but there is \
            already a running manager with that id. This is considered a programmer error since \
            you may be accidentally overwriting an existing manager without knowing.

            To fix you should either destroy the existing manager before creating a new one, or \
            you should not try creating a new one before this one is destroyed.
            """)
        }
        motionManagers.withValue { $0[id] = UncheckedSendable(CMMotionManager()) }
      },
      destroy: { id in
        let id = MotionID(id)
        motionManagers.withValue { $0[id] = nil }
      },
      deviceMotion: { id in
        requireMotionManager(id: MotionID(id))?.value.deviceMotion.map(DeviceMotion.init)
      },
      gyroData: { id in
        requireMotionManager(id: MotionID(id))?.value.gyroData.map(GyroData.init)
      },
      isAccelerometerActive: { id in
        requireMotionManager(id: MotionID(id))?.value.isAccelerometerActive ?? false
      },
      isAccelerometerAvailable: { id in
        requireMotionManager(id: MotionID(id))?.value.isAccelerometerAvailable ?? false
      },
      isDeviceMotionActive: { id in
        requireMotionManager(id: MotionID(id))?.value.isDeviceMotionActive ?? false
      },
      isDeviceMotionAvailable: { id in
        requireMotionManager(id: MotionID(id))?.value.isDeviceMotionAvailable ?? false
      },
      isGyroActive: { id in
        requireMotionManager(id: MotionID(id))?.value.isGyroActive ?? false
      },
      isGyroAvailable: { id in
        requireMotionManager(id: MotionID(id))?.value.isGyroAvailable ?? false
      },
      isMagnetometerActive: { id in
        requireMotionManager(id: MotionID(id))?.value.isMagnetometerActive ?? false
      },
      isMagnetometerAvailable: { id in
        requireMotionManager(id: MotionID(id))?.value.isMagnetometerAvailable ?? false
      },
      magnetometerData: { id in
        requireMotionManager(id: MotionID(id))?.value.magnetometerData.map(MagnetometerData.init)
      },
      set: { id, properties in
        guard let manager = requireMotionManager(id: MotionID(id))?.value
        else { return }

        if let accelerometerUpdateInterval = properties.accelerometerUpdateInterval {
          manager.accelerometerUpdateInterval = accelerometerUpdateInterval
        }
        if let deviceMotionUpdateInterval = properties.deviceMotionUpdateInterval {
          manager.deviceMotionUpdateInterval = deviceMotionUpdateInterval
        }
        if let gyroUpdateInterval = properties.gyroUpdateInterval {
          manager.gyroUpdateInterval = gyroUpdateInterval
        }
        if let magnetometerUpdateInterval = properties.magnetometerUpdateInterval {
          manager.magnetometerUpdateInterval = magnetometerUpdateInterval
        }
        if let showsDeviceMovementDisplay = properties.showsDeviceMovementDisplay {
          manager.showsDeviceMovementDisplay = showsDeviceMovementDisplay
        }
      },
      startAccelerometerUpdates: { id, queue in
        let id = MotionID(id)
        return AsyncThrowingStream { continuation in
          guard let manager = requireMotionManager(id: id)
          else {
            continuation.finish()
            return
          }
          guard accelerometerContinuations.insert(continuation, for: id)
          else {
            continuation.finish()
            return
          }

          manager.value.startAccelerometerUpdates(to: queue) { data, error in
            if let data {
              continuation.yield(.init(data))
            } else if let error {
              continuation.finish(throwing: error)
            }
          }
          continuation.onTermination = { _ in
            manager.value.stopAccelerometerUpdates()
            accelerometerContinuations.removeValue(for: id)
          }
        }
      },
      startDeviceMotionUpdates: { id, frame, queue in
        let id = MotionID(id)
        return AsyncThrowingStream { continuation in
          guard let manager = requireMotionManager(id: id)
          else {
            continuation.finish()
            return
          }
          guard deviceMotionContinuations.insert(continuation, for: id)
          else {
            continuation.finish()
            return
          }

          manager.value.startDeviceMotionUpdates(using: frame, to: queue) { data, error in
            if let data {
              continuation.yield(.init(data))
            } else if let error {
              continuation.finish(throwing: error)
            }
          }
          continuation.onTermination = { _ in
            manager.value.stopDeviceMotionUpdates()
            deviceMotionContinuations.removeValue(for: id)
          }
        }
      },
      startGyroUpdates: { id, queue in
        let id = MotionID(id)
        return AsyncThrowingStream { continuation in
          guard let manager = requireMotionManager(id: id)
          else {
            continuation.finish()
            return
          }
          guard gyroContinuations.insert(continuation, for: id)
          else {
            continuation.finish()
            return
          }

          manager.value.startGyroUpdates(to: queue) { data, error in
            if let data {
              continuation.yield(.init(data))
            } else if let error {
              continuation.finish(throwing: error)
            }
          }
          continuation.onTermination = { _ in
            manager.value.stopGyroUpdates()
            gyroContinuations.removeValue(for: id)
          }
        }
      },
      startMagnetometerUpdates: { id, queue in
        let id = MotionID(id)
        return AsyncThrowingStream { continuation in
          guard let manager = requireMotionManager(id: id)
          else {
            continuation.finish()
            return
          }
          guard magnetometerContinuations.insert(continuation, for: id)
          else {
            continuation.finish()
            return
          }

          manager.value.startMagnetometerUpdates(to: queue) { data, error in
            if let data {
              continuation.yield(.init(data))
            } else if let error {
              continuation.finish(throwing: error)
            }
          }
          continuation.onTermination = { _ in
            manager.value.stopMagnetometerUpdates()
            magnetometerContinuations.removeValue(for: id)
          }
        }
      },
      stopAccelerometerUpdates: { id in
        let id = MotionID(id)
        guard let manager = requireMotionManager(id: id)?.value
        else { return }
        manager.stopAccelerometerUpdates()
        accelerometerContinuations.removeValue(for: id)?.finish()
      },
      stopDeviceMotionUpdates: { id in
        let id = MotionID(id)
        guard let manager = requireMotionManager(id: id)?.value
        else { return }
        manager.stopDeviceMotionUpdates()
        deviceMotionContinuations.removeValue(for: id)?.finish()
      },
      stopGyroUpdates: { id in
        let id = MotionID(id)
        guard let manager = requireMotionManager(id: id)?.value
        else { return }
        manager.stopGyroUpdates()
        gyroContinuations.removeValue(for: id)?.finish()
      },
      stopMagnetometerUpdates: { id in
        let id = MotionID(id)
        guard let manager = requireMotionManager(id: id)?.value
        else { return }
        manager.stopMagnetometerUpdates()
        magnetometerContinuations.removeValue(for: id)?.finish()
      })
  }

  private struct MotionID: Hashable, @unchecked Sendable {
    let rawValue: AnyHashable

    init(_ rawValue: AnyHashable) {
      self.rawValue = rawValue
    }
  }

  private let motionManagers =
    LockIsolated<[MotionID: UncheckedSendable<CMMotionManager>]>([:])

  private let accelerometerContinuations =
    MotionContinuationStore<AccelerometerData>()
  private let deviceMotionContinuations =
    MotionContinuationStore<DeviceMotion>()
  private let gyroContinuations =
    MotionContinuationStore<GyroData>()
  private let magnetometerContinuations =
    MotionContinuationStore<MagnetometerData>()

  private final class MotionContinuationStore<Value>: @unchecked Sendable {
    private let continuations =
      LockIsolated<[MotionID: AsyncThrowingStream<Value, any Error>.Continuation]>([:])

    func insert(
      _ continuation: AsyncThrowingStream<Value, any Error>.Continuation,
      for id: MotionID
    ) -> Bool {
      continuations.withValue {
        guard $0[id] == nil else { return false }
        $0[id] = continuation
        return true
      }
    }

    @discardableResult
    func removeValue(
      for id: MotionID
    ) -> AsyncThrowingStream<Value, any Error>.Continuation? {
      continuations.withValue { $0.removeValue(forKey: id) }
    }
  }

  private func requireMotionManager(id: MotionID) -> UncheckedSendable<CMMotionManager>? {
    let manager = motionManagers.withValue { $0[id] }
    if manager == nil {
      couldNotFindMotionManager(id: id.rawValue)
    }
    return manager
  }

  private func couldNotFindMotionManager(id: Any) {
    assertionFailure(
      """
      A motion manager could not be found with the id \(id). This is considered a programmer error. \
      You should not invoke methods on a motion manager before it has been created or after it \
      has been destroyed. Refactor your code to make sure there is a motion manager created by the \
      time you invoke this endpoint.
      """)
  }
#endif
