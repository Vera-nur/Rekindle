//
//  LikedPostGridViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 28.07.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class LikedPostViewModel: ObservableObject {
    @Published var likedPosts: [Post] = []
    
    func fetchLikedPosts(for userId: String) {
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
