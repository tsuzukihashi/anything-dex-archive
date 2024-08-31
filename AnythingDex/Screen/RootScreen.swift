import SwiftUI
import SwiftData

struct RootScreen: View {
  @EnvironmentObject var appEnvironment: AppEnvironment
  @AppStorage("loginDate") var loginDate: Double = Date().timeIntervalSince1970
  @AppStorage("updatedDate") var updatedDate: Double = Date().timeIntervalSince1970
  @AppStorage("totalItemCount") var totalItemCount: Int = 0
  @ObservedObject var interstitial = Interstitial(type: .requesting)

  init() {
    UITabBar.appearance().isHidden = true
    UINavigationBar.appearance().largeTitleTextAttributes = [
      .font: UIFont(name: .dotFontName, size: 24) as Any
    ]
    UINavigationBar.appearance().titleTextAttributes = [
      .font: UIFont(name: .dotFontName, size: 18) as Any
    ]
  }

  var body: some View {
    VStack(spacing: 0) {
      TabView(selection: $appEnvironment.currentTab) {
        LibraryScreen()
          .tag(RootTabType.index)


        MyPageScreen()
          .tag(RootTabType.mypage)
      }

      Divider()

      DexTabView(selectedTab: $appEnvironment.currentTab)
    }
    .sheet(isPresented: $appEnvironment.showDiscoverView, onDismiss: {
      if totalItemCount % 3 == 0 {
        interstitial.presentInterstitial()
      }
    }) {
      CaptureScreen()
    }
  }
}

#Preview {
  RootScreen()
}
