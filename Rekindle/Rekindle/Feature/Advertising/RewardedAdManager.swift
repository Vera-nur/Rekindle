//
//  RewardedAdManager.swift
//  Rekindle
//
//  Created by Vera Nur on 6.08.2025.
//

import Foundation
import GoogleMobileAds
import UIKit

final class RewardedAdManager: NSObject, ObservableObject {
    @Published private(set) var isLoaded = false
    private var rewardedAd: RewardedAd?
    
    override init() {
        super.init()
        loadAd()
    }
    
    /// Reklamı yükle
    func loadAd() {
        isLoaded = false
        let request = Request()
        
        RewardedAd.load(
            with: "ca-app-pub-3940256099942544/1712485313", // Test birim ID’si
            request: request
        ) { [weak self] ad, error in
            guard let self = self else { return }
            if let error = error {
                print("❌ Rewarded yükleme hatası:", error)
                return
            }
            self.rewardedAd = ad
            ad?.fullScreenContentDelegate = self
            self.isLoaded = true
            print("✅ Rewarded yüklendi")
        }
    }
    
    /// Reklamı göster
    func show() {
        guard
            let root = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .windows
                .first?
                .rootViewController,
            let ad = rewardedAd
        else { return }
        
        ad.present(from: root) {
            // ödül dağıtımını burada yapabilirsin
            print("🎉 Kullanıcı ödülü kazandı!")
        }
    }
}


extension RewardedAdManager: FullScreenContentDelegate {
  func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
    // Reklam kapandıktan sonra yenisini yükle
    loadAd()
  }

  func ad(_ ad: FullScreenPresentingAd,
          didFailToPresentFullScreenContentWithError error: Error) {
    print("❌ Rewarded gösterme hatası:", error)
    loadAd()
  }
}
