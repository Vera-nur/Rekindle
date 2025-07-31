//
//  ProfileAvatarView.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

// ProfileAvatarView.swift

import SwiftUI
import Kingfisher

struct AvatarView: View {
    let image: UIImage?
    let imageUrl: String?
    var size: CGFloat = 80

    var body: some View {
        if let image = image {
            // Yeni seçilmiş UIImage varsa onu göster
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(AppTheme.Colors.textSecondary, lineWidth: 1))
                .shadow(radius: 5)
        } else if let urlString = imageUrl, let url = URL(string: urlString) {
            // URL varsa KFImage ile göster
            KFImage(url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(AppTheme.Colors.textSecondary, lineWidth: 1))
                .shadow(radius: 5)
        } else {
            // Hiçbir şey yoksa default SF Symbol göster
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: size, height: size)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }
}
