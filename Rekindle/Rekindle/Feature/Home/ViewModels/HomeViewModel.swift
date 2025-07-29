//
//  HomeViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 29.07.2025.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var posts: [Post] = []

    func loadPosts() {
        PostService.fetchPublicPosts { [weak self] fetched in
            DispatchQueue.main.async {
                self?.posts = fetched
            }
        }
    }
}


