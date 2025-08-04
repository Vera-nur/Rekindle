//
//  PostImageView.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI
import Kingfisher

struct PostImageView: View {
    let imageUrl: String?

    var body: some View {
        ZStack {
            if let urlString = imageUrl, let url = URL(string: urlString) {
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.horizontal)
            } else {
                PostImagePlaceholder(image: nil)
                    .padding(.horizontal)
            }
        }
    }
}
