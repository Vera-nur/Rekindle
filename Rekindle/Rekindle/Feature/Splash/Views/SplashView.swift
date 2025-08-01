//
//  SplashView.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = SplashViewModel()

    var body: some View {
        Group {
            if viewModel.isActive {
                if authViewModel.hasSeenOnboarding {
                    if authViewModel.isAuthenticated {
                        ContentView()
                    } else {
                        LoginView()
                    }
                } else {
                    OnboardingView()
                        .environmentObject(authViewModel)
                }
            } else {
                VStack {
                    /*Image("App Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)*/

                    Text("Rekindle")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("OnboardingPeach"))
            }
        }
    }
}
