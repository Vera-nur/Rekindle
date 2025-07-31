//
//  PostImagePlaceholder.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI

struct PostImagePlaceholder: View {
    let image: UIImage?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                .frame(height: 250)
                .background(Color.gray.opacity(0.1))

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Text("Henüz fotoğraf seçilmedi".localized())
                    .foregroundColor(.gray)
                    .poppinsFont(size: 14, weight: .regular)
            }
        }
    }
}
