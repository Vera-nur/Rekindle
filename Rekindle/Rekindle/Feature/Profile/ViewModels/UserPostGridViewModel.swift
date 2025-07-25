//
//  UserPostGridViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 25.07.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserPostGridViewModel: ObservableObject {
    @Published var posts: [Post] = []

    func fetchPosts(for userId: String) {
        let db = Firestore.firestore()
        db.collection("posts")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Gönderiler alınamadı: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                self.posts = documents.compactMap { document in
                    try? document.data(as: Post.self)
                }
            }
    }
}
