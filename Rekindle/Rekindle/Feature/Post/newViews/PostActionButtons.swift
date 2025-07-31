//
//  PostActionButtons.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI

struct PostActionButtons: View {
    @ObservedObject var viewModel: PostCardViewModel

    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                viewModel.toggleLike()
            }) {
                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isLiked ? .red : .primary)
                    .font(.title2)
            }

            // İleride başka aksiyonlar eklenirse buraya eklenebilir (yorum, paylaş vs.)
        }
        .padding(.horizontal)
    }
}
