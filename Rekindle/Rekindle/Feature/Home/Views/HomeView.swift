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
            .navigationTitle("Anasayfa".localized())
        }
        .onAppear {
            viewModel.loadPosts()
        }
    }
}

