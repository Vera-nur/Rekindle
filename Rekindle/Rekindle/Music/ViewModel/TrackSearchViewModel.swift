//
//  MusicSearchViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 1.08.2025.
//

import Foundation
import Combine

@MainActor
class TrackSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [Audius.Track] = []
    @Published var isLoading: Bool = false

    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            await performTrending()
        } else {
            await performSearch(query: trimmed)
        }
    }

    private func performSearch(query: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            results = try await MusicService.shared.searchTracks(query: query)
        } catch {
            print("🎵 Search error:", error)
            results = []
        }
    }

    private func performTrending(time: String = "week") async {
        isLoading = true
        defer { isLoading = false }
        do {
            results = try await MusicService.shared.trendingTracks(time: time)
        } catch {
            print("🎵 Trending error:", error)
            results = []
        }
    }
}
