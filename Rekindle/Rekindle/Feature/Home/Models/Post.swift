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
    
    var trackId: String?
    var trackTitle: String?
    var trackArtist: String?
    var trackArtworkUrl: String?
}

//Buraya bakkk 
extension Post {
    static func fromDocument(data: [String: Any]) -> Post {
      return Post(
        id: nil,
        imageUrl: data["imageUrl"] as? String,
        caption: data["caption"] as? String,
        username: data["username"] as? String,
        profileImageUrl: data["profileImageUrl"] as? String,
        trackId: data["trackId"] as? String,
        trackTitle: data["trackTitle"] as? String,
        trackArtist: data["trackArtist"] as? String,
        trackArtworkUrl: data["trackArtworkUrl"] as? String
      )
    }
  }
