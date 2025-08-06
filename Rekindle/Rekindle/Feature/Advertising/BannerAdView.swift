//
//  BannerAdView.swift
//  Rekindle
//
//  Created by Vera Nur on 5.08.2025.
//
import SwiftUI
import GoogleMobileAds

struct BannerViewContainer: UIViewRepresentable {
  let adUnitID: String
    let adSize = AdSize(
      size: CGSize(width: 320, height: 50),
      flags: 0
    )     // tek parametre: sadece size

  func makeUIView(context: Context) -> BannerView {
    let banner = BannerView(adSize: adSize)
    banner.adUnitID = adUnitID
    banner.rootViewController = UIApplication.shared
      .connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first?
      .windows
      .first?
      .rootViewController
    banner.load(Request())
    banner.delegate = context.coordinator
    return banner
  }

  func updateUIView(_ uiView: BannerView, context: Context) { }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, BannerViewDelegate {
    let parent: BannerViewContainer
    init(_ parent: BannerViewContainer) { self.parent = parent }

    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
      print("✅ Banner yüklendi")
    }
    func bannerView(_ bannerView: BannerView,
                    didFailToReceiveAdWithError error: Error) {
      print("❌ Banner yükleme hatası:", error)
    }
  }
}

