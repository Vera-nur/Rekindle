//
//  MusicSearchViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 1.08.2025.
//

import Foundation
import Combine

class TrackSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [Audius.Track] = []
    @Published var isLoading: Bool = false

    func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        isLoading = true
        do {
            let tracks = try await MusicService.shared.searchTracks(query: trimmed)
            results = tracks
        } catch {
            print("🎵 Arama hatası:", error)
            results = []
        }
        isLoading = false
    }
}
