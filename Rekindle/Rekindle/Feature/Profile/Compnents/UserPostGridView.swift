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

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.posts) { post in
                    if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
                        KFImage(url)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .clipped()
                            .cornerRadius(8)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(1, contentMode: .fill)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.fetchPosts(for: userId)
        }
    }
}
