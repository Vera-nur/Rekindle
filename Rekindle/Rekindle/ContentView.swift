//
//  ContentView.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    //@Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var profileVM = UserProfileViewModel()
    @State private var isShowingProfile = true

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house")
                }

            SearchView()
                .tabItem {
                    Label("Ara", systemImage: "magnifyingglass")
                }

            NewPostView()
                .tabItem {
                    Label("Gönderi", systemImage: "plus.circle")
                }

            ProfileView(viewModel: profileVM)
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Profil", systemImage: "person.circle")
                }
        }
    }
}

