//
//  PostCardView.swift
//  Rekindle
//
//  Created by Vera Nur on 24.07.2025.
//

import SwiftUI
import Kingfisher

struct PostCardView: View {
    @StateObject private var vm: PostCardViewModel
    @Environment(\.dismiss) var dismiss
    @State private var editedCaption: String = ""

    init(post: Post, showMenu: Bool = false) {
        _vm = StateObject(
            wrappedValue: PostCardViewModel(post: post, showMenu: showMenu)
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // — Header
            PostHeaderView(
                username: vm.post.username,
                profileImageUrl: vm.post.profileImageUrl,
                showMenu: vm.showMenu,
                onDelete: {
                  vm.deletePost {
                    dismiss()
                  }
                },
                onEdit: {
                    editedCaption = vm.caption
                    vm.startEditingCaption()
                }
            )

            // — Müzik Bilgisi
            if let title = vm.post.trackTitle,
               let artist = vm.post.trackArtist {
                HStack(spacing: 6) {
                    Image(systemName: "music.note")
                    Text("\(artist) · \(title)")
                        .font(.subheadline)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.horizontal)
            }

            // — Görsel + Ses Butonu
            ZStack(alignment: .bottomTrailing) {
                PostImageView(imageUrl: vm.post.imageUrl)

                if vm.player != nil {
                    Button {
                        vm.toggleAudio()
                    } label: {
                        Image(systemName: vm.isPlayingAudio
                              ? "speaker.wave.3.fill"
                              : "speaker.slash.fill")
                            .padding(8)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .padding(12)
                    }
                }
            }

            PostCaptionSection(
                username: vm.post.username,
                caption: vm.caption,
                isEditing: $vm.isEditingCaption,
                editedText: $editedCaption,
                onSave: { vm.saveCaption(editedCaption) { _ in } },
                showSuccess: $vm.showSuccessMessage
            )

            PostActionButtons(viewModel: vm)

            PostTimestampView(date: vm.post.timestamp)
        }
        .onAppear {
            vm.initializeAudio()
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}


