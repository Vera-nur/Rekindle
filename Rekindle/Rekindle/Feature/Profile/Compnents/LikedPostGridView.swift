//
//  LikedPostGridView.swift
//  Rekindle
//
//  Created by Vera Nur on 25.07.2025.
//

import SwiftUI
import Firebase
import Kingfisher

struct LikedPostGridView: View {
    let userId: String
    @State private var likedPosts: [Post] = []
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(likedPosts, id: \.id) { post in
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
            fetchLikedPosts()
        }
    }
    
    func fetchLikedPosts() {
        let db = Firestore.firestore()
        var fetchedPosts: [Post] = []
        
        db.collection("posts").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else { return }
            
            let group = DispatchGroup()
            
            for doc in documents {
                let postId = doc.documentID
                let likesRef = db.collection("posts").document(postId).collection("likes").document(userId)
                
                group.enter()
                likesRef.getDocument { likeDoc, error in
                    if let likeDoc = likeDoc, likeDoc.exists {
                        var post = Post.fromDocument(data: doc.data())
                        post.id = postId
                        fetchedPosts.append(post)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.likedPosts = fetchedPosts
            }
        }
    }
}
