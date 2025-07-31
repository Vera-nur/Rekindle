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
    @State private var selectedPost: Post?

    var body: some View {
        ScrollView {
            PostGridView(posts: viewModel.likedPosts) { post in
                selectedPost = post
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchLikedPosts(for: userId)
        }
        .background(NavigationLink(
            destination: selectedPost.map { PostDetailView(post: $0) },
            isActive: Binding(
                get: { selectedPost != nil },
                set: { if !$0 { selectedPost = nil } }
            )
        ) { EmptyView() })
    }
}
