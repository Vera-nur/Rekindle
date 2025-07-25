//
//  Post.swift
//  Rekindle
//
//  Created by Vera Nur on 24.07.2025.
//

import Foundation
import FirebaseFirestore


struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var imageUrl: String?
    var caption: String?
    var timestamp: Date?
    var userId: String?
    var isPublic: Bool?
    var username: String?
    var isLiked: Bool? = false
    var profileImageUrl: String?
}


extension Post {
    static func fromDocument(data: [String: Any]) -> Post {
        return Post(
            id: nil,
            imageUrl: data["imageUrl"] as? String,
            caption: data["caption"] as? String,
            username: data["username"] as? String,
            profileImageUrl: data["profileImageUrl"] as? String
        )
    }
}
