//
//  PostService.swift
//  Rekindle
//
//  Created by Vera Nur on 24.07.2025.
//

import Foundation
import Firebase
import FirebaseFirestore

class PostService {
    static func fetchPublicPosts(completion: @escaping ([Post]) -> Void) {
        Firestore.firestore()
            .collection("posts")
            .whereField("isPublic", isEqualTo: true)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let posts = documents.compactMap { try? $0.data(as: Post.self) }
                completion(posts)
            }
    }

    static func fetchUserPosts(userId: String, completion: @escaping ([Post]) -> Void) {
        Firestore.firestore()
            .collection("posts")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let posts = documents.compactMap { try? $0.data(as: Post.self) }
                completion(posts)
            }
    }
}
