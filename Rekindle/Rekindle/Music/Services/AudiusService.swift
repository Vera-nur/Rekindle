//
//  AudiusService.swift
//  Rekindle
//
//  Created by Vera Nur on 1.08.2025.
//

import Foundation

// MARK: – MusicService Errors
enum MusicError: Error {
    case invalidURL
    case network(Error)
    case decoding(Error)
}

class MusicService {
    static let shared = MusicService()
    private let baseURL = "https://discoveryprovider.audius.co/v1/tracks/search"

    func searchTracks(query: String) async throws -> [Audius.Track] {
        guard var comp = URLComponents(string: baseURL) else {
            throw MusicError.invalidURL
        }
        comp.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "app_name", value: "rekindle")
        ]
        guard let url = comp.url else {
            throw MusicError.invalidURL
        }

        do {
            // 2) Veri çekme
            let (data, _) = try await URLSession.shared.data(from: url)
            // 3) JSON decode
            let response = try JSONDecoder()
                .decode(Audius.TrackResponse.self, from: data)
            // 4) Sonuçları döndür
            return response.data

        } catch let decodingError as DecodingError {
            // JSON parse hatası
            throw MusicError.decoding(decodingError)
        } catch {
            // Ağ veya diğer hatalar
            throw MusicError.network(error)
        }
    }
}
