import CoreMotion
import Testing

@testable import ComposableCoreMotion

@Suite
struct ComposableCoreMotionTests {
  @Test
  func quaternionInverse() {
    let q = CMQuaternion(x: 1, y: 2, z: 3, w: 4)
    let inv = q.inverse
    let result = q.multiplied(by: inv)

    #expect(result.x == 0)
    #expect(result.y == 0)
    #expect(result.z == 0)
    #expect(result.w == 1)
  }

  @Test
  func quaternionMultiplication() {
    let q1 = CMQuaternion(x: 1, y: 2, z: 3, w: 4)
    let q2 = CMQuaternion(x: -4, y: 3, z: -2, w: 1)
    let result = q1.multiplied(by: q2)

    #expect(result.x == -28)
    #expect(result.y == 4)
    #expect(result.z == 6)
    #expect(result.w == 8)
  }

  @Test
  func rollPitchYaw() {
    let q1 = Attitude(quaternion: .init(x: 1, y: 0, z: 0, w: 0))
    let q2 = Attitude(quaternion: .init(x: 0, y: 1, z: 0, w: 0))
    let q3 = Attitude(quaternion: .init(x: 0, y: 0, z: 1, w: 0))
    let q4 = Attitude(quaternion: .init(x: 0, y: 0, z: 0, w: 1))

    #expect(q1.roll == Double.pi)
    #expect(q1.pitch == 0)
    #expect(q1.yaw == 0)

    #expect(q2.roll == Double.pi)
    #expect(q2.pitch == 0)
    #expect(q2.yaw == Double.pi)

    #expect(q3.roll == 0)
    #expect(q3.pitch == 0)
    #expect(q3.yaw == Double.pi)

    #expect(q4.roll == 0)
    #expect(q4.pitch == 0)
    #expect(q4.yaw == 0)
  }
}
