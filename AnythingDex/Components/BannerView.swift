import SwiftUI
import GoogleMobileAds

enum BannerType {
  case main

  var id: String {
    switch self {
    case .main:
      return ""
    }
  }
}

struct BannerView: UIViewRepresentable {
  private let type: BannerType

  init(type: BannerType) {
    self.type = type
  }

  func makeUIView(context: Context) -> GADBannerView {
    let view = GADBannerView(adSize: GADAdSizeBanner)
#if DEBUG
    // NOTE: DEBUG
    view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
#else
    view.adUnitID = type.id
#endif

    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    view.rootViewController = window?.rootViewController
    let request = GADRequest()
    request.scene = windowScene

    view.load(request)
    return view
  }

  func updateUIView(_ uiView: GADBannerView, context: Context) {
  }
}
