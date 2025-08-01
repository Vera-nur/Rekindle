//
//  RootView.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("didCompleteProfile") var didCompleteProfile: Bool = false


    var body: some View {
        Group {
            if authViewModel.isLoading {
                SplashView()
            } else if !authViewModel.hasSeenOnboarding {
                OnboardingView()
            } else if !isLoggedIn {
                LoginView()
            }else if !didCompleteProfile {
                EditProfileView()
            }else {
                ContentView()
            }
        }
        .onAppear {
            authViewModel.checkAuthenticationStatus()
        }
    }
}
