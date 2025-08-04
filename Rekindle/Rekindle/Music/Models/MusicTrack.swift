//
//  MusicTrack.swift
//  Rekindle
//
//  Created by Vera Nur on 1.08.2025.
//

import Foundation

enum Audius {
  struct TrackResponse: Codable {
    let data: [Track]
  }

  struct Track: Identifiable, Codable {
    let id: String
    let title: String
    let artwork: Artwork?
    let user: User
    let duration: Int
    let isStreamable: Bool

    enum CodingKeys: String, CodingKey {
      case id = "id"
      case title
      case artwork
      case user
      case duration
      case isStreamable = "is_streamable"
    }
  }

  struct Artwork: Codable {
    let small: URL?
    let medium: URL?
    let large: URL?

    enum CodingKeys: String, CodingKey {
      case small  = "150x150"
      case medium = "480x480"
      case large  = "1000x1000"
    }
  }

  struct User: Codable {
    let name: String
  }
}
