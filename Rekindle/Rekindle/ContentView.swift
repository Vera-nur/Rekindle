//
//  ContentView.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var profileVM: UserProfileViewModel
    @State private var isShowingProfile = true
    
    init() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        _profileVM = StateObject(wrappedValue: UserProfileViewModel(userId: uid))
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house")
                }
            

            NavigationView {
                SearchView()
            }
            .tabItem {
                    Label("Ara", systemImage: "magnifyingglass")
                }

            NewPostView()
                .tabItem {
                    Label("Gönderi", systemImage: "plus.circle")
                }

            ProfileView(viewModel: profileVM, isCurrentUser: true)
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Profil", systemImage: "person.circle")
                }
        }
    }
}

