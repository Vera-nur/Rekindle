//
//  LikedPostGridView.swift
//  Rekindle
//
//  Created by Vera Nur on 25.07.2025.
//

import SwiftUI
import Kingfisher

struct LikedPostGridView: View {
    let userId: String
    @StateObject private var viewModel = LikedPostViewModel()
    @State private var selectedPost: Post? = nil

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.likedPosts, id: \.id) { post in
                    Button(action: {
                        selectedPost = post
                    }) {
                        PostImageView(imageUrl: post.imageUrl)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchLikedPosts(for: userId)
        }
        .background(
            NavigationLink(
                destination: selectedPost.map { PostDetailView(post: $0) },
                isActive: Binding(
                    get: { selectedPost != nil },
                    set: { if !$0 { selectedPost = nil } }
                )
            ) {
                EmptyView()
            }
        )
    }
}
