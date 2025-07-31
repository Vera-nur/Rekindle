//
//  PostCardView.swift
//  Rekindle
//
//  Created by Vera Nur on 24.07.2025.
//

import SwiftUI
import Kingfisher

struct PostCardView: View {
    let post: Post
    let showMenu: Bool

    @StateObject private var viewModel: PostCardViewModel
    @State private var isEditingCaption = false
    @State private var editedCaption = ""
    @State private var showSuccessMessage = false
    @Environment(\.dismiss) var dismiss

    init(post: Post, showMenu: Bool = false) {
        self.post = post
        self.showMenu = showMenu
        _viewModel = StateObject(wrappedValue: PostCardViewModel(postId: post.id ?? ""))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Üst Header
            PostHeaderView(
                username: post.username,
                profileImageUrl: post.profileImageUrl,
                showMenu: showMenu,
                onDelete: {
                    viewModel.deletePost {
                        dismiss()
                    }
                },
                onEdit: {
                    editedCaption = post.caption ?? ""
                    isEditingCaption = true
                }
            )

            // Gönderi Görseli
            PostImageView(imageUrl: post.imageUrl)

            // Açıklama Alanı
            PostCaptionSection(
                post: post,
                isEditingCaption: $isEditingCaption,
                editedCaption: $editedCaption,
                viewModel: viewModel,
                showSuccessMessage: $showSuccessMessage
            )

            // Beğen Butonu
            PostActionButtons(viewModel: viewModel)

            // Zaman
            PostTimestampView(date: post.timestamp)
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
