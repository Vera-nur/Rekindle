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
    @StateObject private var viewModel: PostCardViewModel

    init(post: Post) {
        self.post = post
        _viewModel = StateObject(wrappedValue: PostCardViewModel(postId: post.id ?? ""))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Kullanıcı adı
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
            }
            .padding(.horizontal)
            
            // Gönderi görseli
            if let urlString = post.imageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
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
            
            HStack(spacing: 6) {
                Text(post.username ?? "Kullanıcı")
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
            
            }
            .padding(.vertical)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(radius: 3)
        }
    }

