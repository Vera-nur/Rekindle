//
//  PostGridView.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI

struct PostGridView: View {
    let posts: [Post]
    let onSelect: (Post) -> Void

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(posts) { post in
                Button {
                    onSelect(post)
                } label: {
                    GridPostImageView(imageUrl: post.imageUrl)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
