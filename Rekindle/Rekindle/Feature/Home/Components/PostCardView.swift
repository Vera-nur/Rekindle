//
//  PostCardView.swift
//  Rekindle
//
//  Created by Vera Nur on 24.07.2025.
//

import SwiftUI

struct PostCardView: View {
    let post: Post
    @State private var isLiked: Bool
    
    init(post: Post) {
        self.post = post
        self._isLiked = State(initialValue: post.isLiked ?? false)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Kullanıcı adı
            Text(post.username ?? "Bilinmeyen Kullanıcı")
             .font(.headline)
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
                 isLiked.toggle()
                 }) {
                 Image(systemName: isLiked ? "heart.fill" : "heart")
                 .foregroundColor(isLiked ? .red : .primary)
                 .font(.title2)
                 }
                 Spacer()
                 }
                 .padding(.horizontal)
                
                // Açıklama
            if let caption = post.caption {
                Text(caption)
                    .font(.subheadline)
                    .padding(.horizontal)
            } else {
                Text("Açıklama yok.")
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.horizontal)
            }
            }
            .padding(.vertical)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(radius: 3)
        }
    }

