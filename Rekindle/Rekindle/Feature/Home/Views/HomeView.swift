//
//  HomeViews.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//
import SwiftUI
import Kingfisher

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.posts) { post in
                        PostCardView(post: post, showMenu: false)
                    }
                }
                .padding()
            }
            .navigationTitle("Anasayfa")
        }
        .onAppear {
            
            
            viewModel.loadPosts()
        }
    }
}
