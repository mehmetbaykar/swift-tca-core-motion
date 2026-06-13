import ComposableArchitecture
import ComposableCoreMotion
import CoreMotion
import SwiftUI

private let readMe = """
  This demonstrates how to work with the MotionManager API from Apple's Motion framework.

  The Motion APIs are not available in SwiftUI previews or simulators. However, thanks to how \
  the Composable Architecture models its dependencies and effects, it is trivial to substitute \
  a mock MotionManager into the SwiftUI preview so that we can still play around with its basic \
  functionality.

  We also have the background of the screen change colors depending on if the screen is facing \
  you or facing away. We do this by computing how much the device's attitude has changed from \
  the moment you started recording, and then checking the device yaw to see which way it is \
  facing.
  """

@Reducer
struct AppFeature {
  @ObservableState
  struct State: Equatable {
    var alert: String?
    var facingDirection: Direction?
    var initialAttitude: Attitude?
    var isRecording = false
    var z: [Double] = []

    enum Direction: Equatable {
      case backward
      case forward
    }
  }

  enum Action: Equatable {
    case alertDismissed
    case motionUpdate(Result<DeviceMotion, NSError>)
    case recordingButtonTapped
  }

  @Dependency(\.motionManager) var motionManager

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .alertDismissed:
        state.alert = nil
        return .none

      case .motionUpdate(.failure):
        state.alert = """
          We encountered a problem with the motion manager. Make sure you run this demo on a real \
          device, not the simulator.
          """
        state.isRecording = false
        return .run { _ in
          await motionManager.stopDeviceMotionUpdates(id: MotionManagerID())
          await motionManager.destroy(id: MotionManagerID())
        }

      case .motionUpdate(.success(let motion)):
        state.initialAttitude =
          state.initialAttitude
          ?? motionManager.deviceMotion(id: MotionManagerID())?.attitude

        if let initialAttitude = state.initialAttitude {
          let newAttitude = motion.attitude.multiply(byInverseOf: initialAttitude)
          if abs(newAttitude.yaw) < Double.pi / 2 {
            state.facingDirection = .forward
          } else {
            state.facingDirection = .backward
          }
        }

        state.z.append(
          motion.gravity.x * motion.userAcceleration.x
            + motion.gravity.y * motion.userAcceleration.y
            + motion.gravity.z * motion.userAcceleration.z
        )
        state.z.removeFirst(max(0, state.z.count - 350))

        return .none

      case .recordingButtonTapped:
        state.isRecording.toggle()

        switch state.isRecording {
        case true:
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

        case false:
          state.initialAttitude = nil
          state.facingDirection = nil
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

struct AppView: View {
  let store: StoreOf<AppFeature>

  var body: some View {
    VStack {
      Text(readMe)
        .multilineTextAlignment(.leading)
        .layoutPriority(1)

      Spacer(minLength: 100)

      plot(buffer: store.z, scale: 40)

      Button {
        store.send(.recordingButtonTapped)
      } label: {
        HStack {
          Image(
            systemName: store.isRecording
              ? "stop.circle.fill" : "arrowtriangle.right.circle.fill"
          )
          .font(.title)
          Text(store.isRecording ? "Stop Recording" : "Start Recording")
        }
        .foregroundStyle(.white)
        .padding()
        .background(store.isRecording ? Color.red : .blue)
        .clipShape(.rect(cornerRadius: 16))
      }
    }
    .padding()
    .background(store.facingDirection == .backward ? Color.green : Color.clear)
    .alert(
      "Motion manager problem",
      isPresented: Binding(
        get: { store.alert != nil },
        set: { isPresented in
          if !isPresented {
            store.send(.alertDismissed)
          }
        }
      )
    ) {
    } message: {
      if let alert = store.alert {
        Text(alert)
      }
    }
  }
}

func plot(buffer: [Double], scale: Double) -> Path {
  Path { path in
    let baseline: Double = 50
    let size: Double = 3
    for (offset, value) in buffer.enumerated() {
      let point = CGPoint(x: Double(offset) - size / 2, y: baseline - value * scale - size / 2)
      let rect = CGRect(origin: point, size: CGSize(width: size, height: size))
      path.addEllipse(in: rect)
    }
  }
}

#Preview {
  AppView(
    store: Store(
      initialState: AppFeature.State(
        z: (1...350).map {
          2 * sin(Double($0) / 20) + cos(Double($0) / 8)
        }
      )
    ) {
      AppFeature()
    } withDependencies: {
      $0.motionManager = .previewValue
    }
  )
}

extension MotionManager {
  static let previewValue = MotionManager.unimplemented(
    create: { _ in },
    destroy: { _ in },
    deviceMotion: { _ in nil },
    startDeviceMotionUpdates: { _, _, _ in
      AsyncThrowingStream { continuation in
        let task = Task {
          while !Task.isCancelled {
            let t = Date.now.timeIntervalSince1970 * 2
            continuation.yield(
              DeviceMotion(
                attitude: .init(quaternion: .init(x: 1, y: 0, z: 0, w: 0)),
                gravity: .init(x: sin(2 * t), y: -cos(-t), z: sin(3 * t)),
                heading: 0,
                magneticField: .init(field: .init(x: 0, y: 0, z: 0), accuracy: .high),
                rotationRate: .init(x: 0, y: 0, z: 0),
                timestamp: Date.now.timeIntervalSince1970,
                userAcceleration: .init(x: -cos(-3 * t), y: sin(2 * t), z: -cos(t))
              )
            )
            try? await Task.sleep(for: .milliseconds(10))
          }
        }
        continuation.onTermination = { _ in task.cancel() }
      }
    },
    stopDeviceMotionUpdates: { _ in }
  )
}
