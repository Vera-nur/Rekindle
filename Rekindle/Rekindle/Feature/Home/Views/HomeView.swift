//
//  HomeViews.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//
import SwiftUI
import Kingfisher

struct HomeView: View {
    @State private var posts: [Post] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(posts) { post in
                        VStack(alignment: .leading, spacing: 8) {
                            if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
                                KFImage(url)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                            } else {
                                Text("Görsel bulunamadı")
                                    .foregroundColor(.gray)
                                    .italic()
                            }

                            if let caption = post.caption {
                                Text(caption)
                                    .font(.body)
                            } else {
                                Text("Açıklama yok.")
                                    .foregroundColor(.gray)
                                    .italic()
                            }

                            HStack {
                                Image(systemName: "heart")
                                Text("Beğen")
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Anasayfa")
        }
        .onAppear {
            PostService.fetchPublicPosts { fetched in
                self.posts = fetched
            }
        }
    }
}
