import Foundation

enum LottieAnimationType: String {
  case cow
  case creeper
  case enderman
  case pig
  case sheep
  case skeleton
  case steve
  case zombie
  case coin

  static var loadingAnimations: [LottieAnimationType] {
    [.cow, .creeper, .enderman, .pig, .sheep, .skeleton, .steve, .zombie]
  }

  static func random() -> LottieAnimationType {
    loadingAnimations.randomElement() ?? .steve
  }
}
