//
//  UserPostGridView.swift
//  Rekindle
//
//  Created by Vera Nur on 25.07.2025.
//

import SwiftUI
import Kingfisher

struct UserPostGridView: View {
    let userId: String
    @StateObject private var viewModel = UserPostGridViewModel()
    @State private var selectedPost: Post?

    var body: some View {
        ScrollView {
            PostGridView(posts: viewModel.posts) { post in
                selectedPost = post
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchPosts(for: userId)
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
