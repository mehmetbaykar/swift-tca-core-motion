#if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
  import ComposableArchitecture
  import CoreMotion
  import Foundation

  @available(iOS 14, *)
  @available(macCatalyst 14, *)
  @available(macOS, unavailable)
  @available(tvOS, unavailable)
  @available(watchOS 7, *)
  extension HeadphoneMotionManager {
    public static let live = HeadphoneMotionManager(
      create: { id in
        let id = HeadphoneMotionID(id)
        return AsyncStream { continuation in
          if headphoneDependencies.withValue({ $0[id] != nil }) {
            assertionFailure(
              """
              You are attempting to create a headphone motion manager with the id \(id.rawValue), \
              but there is already a running manager with that id. This is considered a programmer \
              error since you may be accidentally overwriting an existing manager without knowing.

              To fix you should either destroy the existing manager before creating a new one, or \
              you should not try creating a new one before this one is destroyed.
              """)
          }

          let manager = CMHeadphoneMotionManager()
          let delegate = Delegate(continuation)
          manager.delegate = delegate

          let dependency = UncheckedSendable(
            Dependencies(
              delegate: delegate,
              manager: manager,
              continuation: continuation
            )
          )

          headphoneDependencies.withValue {
            $0[id] = dependency
          }

          continuation.onTermination = { _ in
            headphoneDependencies.withValue { $0[id] = nil }
          }
        }
      },
      destroy: { id in
        let id = HeadphoneMotionID(id)
        headphoneDependencies.withValue { $0[id] = nil }
      },
      deviceMotion: { id in
        requireHeadphoneMotionManager(id: HeadphoneMotionID(id))?.value.deviceMotion.map(
          DeviceMotion.init)
      },
      isDeviceMotionActive: { id in
        requireHeadphoneMotionManager(id: HeadphoneMotionID(id))?.value.isDeviceMotionActive
          ?? false
      },
      isDeviceMotionAvailable: { id in
        requireHeadphoneMotionManager(id: HeadphoneMotionID(id))?.value.isDeviceMotionAvailable
          ?? false
      },
      startDeviceMotionUpdates: { id, queue in
        let id = HeadphoneMotionID(id)
        return AsyncThrowingStream<DeviceMotion, any Error> { continuation in
          guard let manager = requireHeadphoneMotionManager(id: id)
          else {
            continuation.finish()
            return
          }
          guard headphoneDeviceMotionContinuations.insert(continuation, for: id)
          else {
            continuation.finish()
            return
          }

          manager.value.startDeviceMotionUpdates(to: queue) { data, error in
            if let data {
              continuation.yield(.init(data))
            } else if let error {
              continuation.finish(throwing: error)
            }
          }
          continuation.onTermination = { _ in
            manager.value.stopDeviceMotionUpdates()
            headphoneDeviceMotionContinuations.removeValue(for: id)
          }
        }
      },
      stopDeviceMotionUpdates: { id in
        let id = HeadphoneMotionID(id)
        guard let manager = requireHeadphoneMotionManager(id: id)?.value
        else { return }
        manager.stopDeviceMotionUpdates()
        headphoneDeviceMotionContinuations.removeValue(for: id)?.finish()
      }
    )
  }

  private struct HeadphoneMotionID: Hashable, @unchecked Sendable {
    let rawValue: AnyHashable

    init(_ rawValue: AnyHashable) {
      self.rawValue = rawValue
    }
  }

  private final class Delegate: NSObject, CMHeadphoneMotionManagerDelegate {
    let continuation: AsyncStream<HeadphoneMotionManager.Action>.Continuation

    init(_ continuation: AsyncStream<HeadphoneMotionManager.Action>.Continuation) {
      self.continuation = continuation
    }

    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
      continuation.yield(.didConnect)
    }

    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
      continuation.yield(.didDisconnect)
    }
  }

  private struct Dependencies {
    let delegate: Delegate
    let manager: CMHeadphoneMotionManager
    let continuation: AsyncStream<HeadphoneMotionManager.Action>.Continuation
  }

  private let headphoneDependencies =
    LockIsolated<[HeadphoneMotionID: UncheckedSendable<Dependencies>]>([:])
  private let headphoneDeviceMotionContinuations =
    HeadphoneMotionContinuationStore<DeviceMotion>()

  private final class HeadphoneMotionContinuationStore<Value>: @unchecked Sendable {
    private let continuations =
      LockIsolated<[HeadphoneMotionID: AsyncThrowingStream<Value, any Error>.Continuation]>([:])

    func insert(
      _ continuation: AsyncThrowingStream<Value, any Error>.Continuation,
      for id: HeadphoneMotionID
    ) -> Bool {
      continuations.withValue {
        guard $0[id] == nil else { return false }
        $0[id] = continuation
        return true
      }
    }

    @discardableResult
    func removeValue(
      for id: HeadphoneMotionID
    ) -> AsyncThrowingStream<Value, any Error>.Continuation? {
      continuations.withValue { $0.removeValue(forKey: id) }
    }
  }

  private func requireHeadphoneMotionManager(
    id: HeadphoneMotionID
  ) -> UncheckedSendable<CMHeadphoneMotionManager>? {
    let dependency = headphoneDependencies.withValue { $0[id] }
    let manager = dependency.map { UncheckedSendable($0.value.manager) }
    if manager == nil {
      couldNotFindHeadphoneMotionManager(id: id.rawValue)
    }
    return manager
  }

  private func couldNotFindHeadphoneMotionManager(id: Any) {
    assertionFailure(
      """
      A headphone motion manager could not be found with the id \(id). This is considered a \
      programmer error. You should not invoke methods on a motion manager before it has been \
      created or after it has been destroyed. Refactor your code to make sure there is a headphone \
      motion manager created by the time you invoke this endpoint.
      """)
  }
#endif
