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
    var caption: String
    var timestamp: Date
    var userId: String
    var isPublic: Bool
    
    var username: String?
    var isLiked: Bool = false
}

