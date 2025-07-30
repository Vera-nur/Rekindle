//
//  UserRowView.swift
//  Rekindle
//
//  Created by Vera Nur on 30.07.2025.
//

import SwiftUI
import Kingfisher

struct UserRowView: View {
    let user: User

    var body: some View {
        HStack(spacing: 12) {
            if let imageUrl = user.profileImageUrl,
               !imageUrl.isEmpty,
               let url = URL(string: imageUrl) {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
            }

            VStack(alignment: .leading) {
                Text(user.username ?? "")
                    .font(.headline)

                Text(user.fullName ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 6)
    }
}
