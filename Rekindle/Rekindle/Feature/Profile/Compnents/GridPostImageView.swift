//
//  PostImageView.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI
import Kingfisher

struct GridPostImageView: View {
    let imageUrl: String?

    var body: some View {
        if let imageUrl = imageUrl,
           let url = URL(string: imageUrl) {
            KFImage(url)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .clipped()
                .cornerRadius(8)
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(1, contentMode: .fill)
                .cornerRadius(8)
        }
    }
}
