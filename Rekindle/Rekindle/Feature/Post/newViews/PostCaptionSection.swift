//
//  PostCaptionSection.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI

struct PostCaptionSection: View {
    let post: Post
    @Binding var isEditingCaption: Bool
    @Binding var editedCaption: String
    @ObservedObject var viewModel: PostCardViewModel
    @Binding var showSuccessMessage: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 6) {
                Text("\(post.username ?? "Kullanıcı".localized()):")
                    .poppinsFont(size: 13, weight: .semibold)

                if isEditingCaption {
                    VStack(alignment: .leading, spacing: 6) {
                        AppTextField(
                            title: nil,
                            placeholder: "Yeni açıklama...".localized(),
                            text: $editedCaption
                        )

                        PrimaryButton(title: "Kaydet".localized()) {
                            viewModel.updateCaption(editedCaption) { success in
                                if success {
                                    isEditingCaption = false
                                    showSuccessMessage = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showSuccessMessage = false
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    if let caption = post.caption {
                        Text(caption)
                            .poppinsFont(size: 13)
                    } else {
                        Text("Açıklama yok.".localized())
                            .foregroundColor(.gray)
                            .italic()
                            .poppinsFont(size: 13)
                    }
                }

                Spacer()
            }

            if showSuccessMessage {
                Text("✅ Güncellendi!".localized())
                    .font(.caption)
                    .foregroundColor(.green)
                    .transition(.opacity)
            }
        }
        .padding(.horizontal)
    }
}
