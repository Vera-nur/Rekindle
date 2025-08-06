//
//  InterstitialAdManager.swift
//  Rekindle
//
//  Created by Vera Nur on 6.08.2025.
//

import Foundation
import GoogleMobileAds
import UIKit

final class InterstitialAdManager: NSObject, ObservableObject {
  @Published private(set) var isLoaded = false
  private var interstitial: InterstitialAd?

  override init() {
    super.init()
    loadAd()
  }

    func loadAd() {
      isLoaded = false
      let request = Request()   // ← GADRequest yerine Request()

      // — Option A: withAdUnitID:request:completionHandler: —
      InterstitialAd.load(
        with: "ca-app-pub-3940256099942544/4411468910",  // Test ID’n
        request: request
      ) { [weak self] ad, error in
        guard let self = self else { return }
        if let error = error {
          print("❌ Interstitial yükleme hatası:", error)
          return
        }
        self.interstitial = ad
        ad?.fullScreenContentDelegate = self
        self.isLoaded = true
        print("✅ Interstitial yüklendi")
      }
    }

    func show() {
      guard
        let root = UIApplication.shared
          .connectedScenes
          .compactMap({ $0 as? UIWindowScene })
          .first?
          .windows
          .first(where: { $0.isKeyWindow })?
          .rootViewController,
        root.presentedViewController == nil,   // 😊 bu kontrol
        let ad = interstitial
      else { return }
      ad.present(from: root)
    }
}

extension InterstitialAdManager: FullScreenContentDelegate {
  func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
    // reklam kapandıktan sonra yenisini yükle
    loadAd()
  }

  func ad(_ ad: FullScreenPresentingAd,
          didFailToPresentFullScreenContentWithError error: Error) {
    print("❌ Interstitial gösterme hatası:", error)
    loadAd()
  }
}
