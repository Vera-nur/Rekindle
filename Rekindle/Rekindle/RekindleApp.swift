//
//  RekindleApp.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//


import SwiftUI
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()

    // Başlatmayı ya parametresiz yap:
      MobileAds.shared.start()
    // — veya —
    // GADMobileAds.sharedInstance().start { status in
    //   // reklam SDK’sı hazır olduğunda burası çalışır
    // }

    return true
  }
}

@main
struct RekindleApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var authViewModel = AuthViewModel()
    @StateObject private var interstitial      = InterstitialAdManager()
    @StateObject private var rewardedAdManager = RewardedAdManager()

  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(authViewModel)
        .environmentObject(interstitial)
        .environmentObject(rewardedAdManager)
    }
  }
}
