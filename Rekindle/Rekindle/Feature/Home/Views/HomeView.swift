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
                        PostCardView(post: post)
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
