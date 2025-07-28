//
//  PostDetailView.swift
//  Rekindle
//
//  Created by Vera Nur on 28.07.2025.
//

import SwiftUI

struct PostDetailView: View {
    let post: Post

    var body: some View {
        ScrollView {
            PostCardView(post: post, showMenu: true)
        }
        .navigationTitle("Gönderi Detayı")
        .navigationBarTitleDisplayMode(.inline)
    }
}
