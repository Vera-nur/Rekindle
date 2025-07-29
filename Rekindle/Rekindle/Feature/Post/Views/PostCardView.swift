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
    var showMenu: Bool = false
    @StateObject private var viewModel: PostCardViewModel

    @Environment(\.dismiss) private var dismiss

    init(post: Post, showMenu: Bool = false) {
        self.post = post
        self.showMenu = showMenu
        _viewModel = StateObject(wrappedValue: PostCardViewModel(postId: post.id ?? ""))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                if let profileUrl = post.profileImageUrl, let url = URL(string: profileUrl) {
                    KFImage(url)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.gray)
                }

                Text(post.username ?? "Bilinmeyen Kullanıcı")
                    .poppinsFont(size: 16, weight: .semibold)

                Spacer()
                
                if showMenu {
                    Menu {
                        Button(role: .destructive) {
                            viewModel.deletePost {
                                dismiss()
                            }
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }

                        Button {
                        } label: {
                            Label("Düzenle", systemImage: "pencil")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.horizontal)

            // Post görseli
            if let urlString = post.imageUrl, let url = URL(string: urlString) {
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            // Kalp butonu
            HStack {
                Button(action: {
                    viewModel.toggleLike()
                }) {
                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isLiked ? .red : .primary)
                        .font(.title2)
                }
            }
            .padding(.horizontal)

            // Açıklama
            HStack(spacing: 6) {
                Text("\(post.username ?? "Kullanıcı"):")
                    .poppinsFont(size: 13, weight: .semibold)
                    .foregroundColor(.primary)

                if let caption = post.caption {
                    Text(caption)
                        .poppinsFont(size: 13, weight: .regular)
                } else {
                    Text("Açıklama yok.")
                        .foregroundColor(.gray)
                        .italic()
                        .poppinsFont(size: 13)
                }

                Spacer()
            }
            .padding(.horizontal)
            
            if let date = post.timestamp {
                Text(date.formatted(date: .abbreviated, time: .omitted)) 
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}
