import GoogleMobileAds

enum InterstitialType {
  case requesting

  var id: String {
    #if DEBUG
    return "ca-app-pub-3940256099942544/4411468910"
    #else
    switch self {
    case .requesting:
      return ""
    }
    #endif
  }
}

class Interstitial: NSObject, GADFullScreenContentDelegate, ObservableObject {
  @Published var interstitialAdLoaded: Bool = false

  var interstitialAd: GADInterstitialAd?
  private let type: InterstitialType

  init(type: InterstitialType) {
    self.type = type
    super.init()
    loadInterstitial()
  }

  // リワード広告の読み込み
  func loadInterstitial() {
    let request = GADRequest()
    request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene

    GADInterstitialAd.load(withAdUnitID: type.id, request: request) { (ad, error) in
      if let _ = error {
        self.interstitialAdLoaded = false
        return
      }
      self.interstitialAdLoaded = true
      self.interstitialAd = ad
      self.interstitialAd?.fullScreenContentDelegate = self
    }
  }

  // インタースティシャル広告の表示
  func presentInterstitial() {
    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let root = scene?.windows.first?.rootViewController
    if let ad = interstitialAd {
      ad.present(fromRootViewController: root!)
      self.interstitialAdLoaded = false
    } else {
      self.interstitialAdLoaded = false
      self.loadInterstitial()
    }
  }
  // 失敗通知
  func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    self.interstitialAdLoaded = false
    self.loadInterstitial()
  }

  // 表示通知
  func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    self.interstitialAdLoaded = false
  }

  // クローズ通知
  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    self.interstitialAdLoaded = false
  }
}
