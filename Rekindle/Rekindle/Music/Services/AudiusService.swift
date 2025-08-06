//
//  AudiusService.swift
//  Rekindle
//
//  Created by Vera Nur on 1.08.2025.
//

import Foundation

enum MusicError: Error {
    case invalidURL
    case network(Error)
    case decoding(Error)
}

class MusicService {
    static let shared = MusicService()
    private let searchBaseURL = "https://discoveryprovider.audius.co/v1/tracks/search"
    private let trendingBaseURL = "https://discoveryprovider.audius.co/v1/tracks/trending"
    private let appName = "rekindle"

    func searchTracks(query: String) async throws -> [Audius.Track] {
        guard var comp = URLComponents(string: searchBaseURL) else {
            throw MusicError.invalidURL
        }
        comp.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "app_name", value: appName)
        ]
        guard let url = comp.url else {
            throw MusicError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(Audius.TrackResponse.self, from: data)
        return response.data
    }

    func trendingTracks(time: String = "week") async throws -> [Audius.Track] {
        guard var comp = URLComponents(string: trendingBaseURL) else {
            throw MusicError.invalidURL
        }
        comp.queryItems = [
            URLQueryItem(name: "time", value: time),
            URLQueryItem(name: "app_name", value: appName)
        ]
        guard let url = comp.url else {
            throw MusicError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(Audius.TrackResponse.self, from: data)
        return response.data
    }
}
