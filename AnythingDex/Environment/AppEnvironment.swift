import Foundation

final class AppEnvironment: ObservableObject {
  @Published var currentTab: RootTabType = .index
  @Published var showDiscoverView: Bool = false
  static let shared: AppEnvironment = .init()
  private init() {}
}
