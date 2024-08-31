import Foundation

enum RootTabType: String, CaseIterable, Identifiable {
  case index = "Index"
  case mypage = "MyPage"

  var id: String { rawValue }

  var index: Int {
    switch self {
    case .index:
      return 0
    case .mypage:
      return 1
    }
  }

  var imageName: String {
    switch self {
    case .index:
      return "Dictionary"
    case .mypage:
      return "trainer"
    }
  }

  var name: String {
    switch self {
    case .index:
      return NSLocalizedString("Library", comment: "")
    case .mypage:
      return NSLocalizedString("You", comment: "")
    }
  }

}
