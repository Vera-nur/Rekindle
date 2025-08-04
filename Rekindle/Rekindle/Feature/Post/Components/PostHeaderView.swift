//
//  PostHeaderView.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI
import Kingfisher

struct PostHeaderView: View {
    let username: String?
    let profileImageUrl: String?
    let showMenu: Bool
    let onDelete: () -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            if let urlString = profileImageUrl, let url = URL(string: urlString) {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.gray)
            }

            Text(username ?? "Bilinmeyen Kullanıcı".localized())
                .poppinsFont(size: 16, weight: .semibold)

            Spacer()

            if showMenu {
                Menu {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Sil".localized(), systemImage: "trash")
                    }

                    Button {
                        onEdit()
                    } label: {
                        Label("Düzenle".localized(), systemImage: "pencil")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .padding(.horizontal)
                }
            }
        }
        .padding(.horizontal)
    }
}
