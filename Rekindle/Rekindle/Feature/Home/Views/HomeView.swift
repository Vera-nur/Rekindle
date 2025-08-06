//
//  HomeViews.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//
import SwiftUI
import Kingfisher
import GoogleMobileAds

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var interstitial = InterstitialAdManager()
    @StateObject private var rewarded     = RewardedAdManager()
    @State private var isFirstAppearance = true
    @State private var didShowInterstitial = false

    var body: some View {
        NavigationView {
            VStack(spacing :0){
                ScrollView {
                    if viewModel.posts.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "square.stack.3d.down.forward")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            
                            Text("Henüz paylaşım yok.".localized())
                                .poppinsFont(size: 16)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 100)
                    } else {
                        VStack(spacing: 20) {
                            ForEach(viewModel.posts) { post in
                                PostCardView(post: post, showMenu: false)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
                BannerViewContainer(adUnitID: "ca-app-pub-3940256099942544/2435281174")
                .frame(height: 50)
            }
            .navigationTitle("Anasayfa".localized())
            
        }
        .onAppear {
            viewModel.loadPosts()
            interstitial.loadAd()

            if isFirstAppearance {
                // ― İlk açılma: skip
                isFirstAppearance = false
            } else if !didShowInterstitial {
                didShowInterstitial = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if interstitial.isLoaded {
                        interstitial.show()
                    }
                }
            }
        }
    }
}

