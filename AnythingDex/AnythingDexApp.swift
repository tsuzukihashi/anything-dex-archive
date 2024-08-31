import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import FirebaseCore

@main
struct AnythingDexApp: App {
  init() {
    FirebaseApp.configure()
  }

  var body: some Scene {
    WindowGroup {
      RootScreen()
        .environmentObject(AppEnvironment.shared)
        .modelContainer(for: [Item.self])
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
          ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
            GADMobileAds.sharedInstance().start(completionHandler: nil)
          })
        }
    }
  }
}
