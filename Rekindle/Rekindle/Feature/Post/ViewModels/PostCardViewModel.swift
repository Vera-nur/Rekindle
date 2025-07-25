//
//  PostCardViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 25.07.2025.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class PostCardViewModel: ObservableObject {
    @Published var isLiked: Bool = false
    let postId: String
    let userId: String

    init(postId: String) {
        self.postId = postId
        self.userId = Auth.auth().currentUser?.uid ?? ""
        checkIfLiked()
    }

    func checkIfLiked() {
        let docRef = Firestore.firestore()
            .collection("posts")
            .document(postId)
            .collection("likes")
            .document(userId)

        docRef.getDocument { snapshot, _ in
            if snapshot?.exists == true {
                DispatchQueue.main.async {
                    self.isLiked = true
                }
            }
        }
    }

    func toggleLike() {
        let likesRef = Firestore.firestore()
            .collection("posts")
            .document(postId)
            .collection("likes")
            .document(userId)

        if isLiked {
            // Beğeniyi kaldır
            likesRef.delete { _ in
                DispatchQueue.main.async {
                    self.isLiked = false
                }
            }
        } else {
            // Beğeniyi ekle
            let data: [String: Any] = [
                "likedAt": Timestamp()
            ]
            likesRef.setData(data) { _ in
                DispatchQueue.main.async {
                    self.isLiked = true
                }
            }
        }
    }
}
