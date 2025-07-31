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
            AvatarView(image: nil, imageUrl: user.profileImageUrl, size: 40)

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
