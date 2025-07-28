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
import FirebaseStorage

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
    
    func deletePost(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let postRef = db.collection("posts").document(postId)

        // Önce dökümanı al, imageUrl'yi bul
        postRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let imageUrl = data["imageUrl"] as? String else {
                print("⚠️ Post silinirken imageUrl alınamadı.")
                // Yine de dökümanı sil
                postRef.delete { error in
                    if let error = error {
                        print("❌ Post silinemedi: \(error.localizedDescription)")
                    } else {
                        print("✅ Post silindi (image alınamadı).")
                        completion()
                    }
                }
                return
            }

            // Resmi storage'dan sil
            let storageRef = storage.reference(forURL: imageUrl)
            storageRef.delete { error in
                if let error = error {
                    print("⚠️ Görsel silinemedi: \(error.localizedDescription)")
                } else {
                    print("🧹 Görsel başarıyla silindi.")
                }

                // Firestore dökümanını sil
                postRef.delete { error in
                    if let error = error {
                        print("❌ Post silinemedi: \(error.localizedDescription)")
                    } else {
                        print("✅ Post başarıyla silindi.")
                        completion()
                    }
                }
            }
        }
    }
}
