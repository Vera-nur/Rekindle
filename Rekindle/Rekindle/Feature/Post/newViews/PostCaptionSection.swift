//
//  PostCaptionSection.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI

struct PostCaptionSection: View {
    let username: String?
    let caption: String
    @Binding var isEditing: Bool
    @Binding var editedText: String
    let onSave: () -> Void
    @Binding var showSuccess: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let user = username {
                Text("\(user):")
                    .poppinsFont(size: 13, weight: .semibold)
            }

            if isEditing {
                AppTextField(
                    title: nil,
                    placeholder: "Yeni açıklama...".localized(),
                    text: $editedText
                )
                PrimaryButton(title: "Kaydet".localized()) {
                    onSave()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text(caption.isEmpty ? "Açıklama yok.".localized() : caption)
                    .poppinsFont(size: 13)
            }

            if showSuccess {
                Text("✅ Güncellendi!".localized())
                    .font(.caption)
                    .foregroundColor(.green)
                    .transition(.opacity)
            }
        }
        .padding(.horizontal)
    }
}
