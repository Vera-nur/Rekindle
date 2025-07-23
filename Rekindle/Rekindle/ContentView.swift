//
//  ContentView.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var userProfileViewModel = UserProfileViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isProfilePresented = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house")
                }

            ProfileView(
                viewModel: userProfileViewModel,
                isShowing: $isProfilePresented
            )
            .environmentObject(authViewModel)
            .tabItem {
                Label("Profil", systemImage: "person.circle")
            }
        }
    }
}
