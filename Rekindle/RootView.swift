//
//  RootView.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isLoading {
                SplashView()
            } else if !authViewModel.hasSeenOnboarding {
                OnboardingView()
            } else if !authViewModel.isAuthenticated {
                LoginView()
            } else {
                ContentView()
            }
        }
        .onAppear {
            authViewModel.checkAuthenticationStatus()
        }
    }
}
