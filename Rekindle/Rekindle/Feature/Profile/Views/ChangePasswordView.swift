//
//  ChangePasswordView.swift
//  moviesList
//
//  Created by Vera Nur on 16.07.2025.
//

import SwiftUI

struct ChangePasswordView: View {
    @ObservedObject var viewModel: UserProfileViewModel

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Mevcut Şifre".localized())
                    .poppinsFont(size: 14, weight: .medium)

                AppTextField(
                    title: nil,
                    placeholder: "Mevcut şifrenizi girin".localized(),
                    text: $viewModel.currentPassword,
                    isSecure: true
                )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Yeni Şifre".localized())
                    .poppinsFont(size: 14, weight: .medium)

                AppTextField(
                    title: nil,
                    placeholder: "Yeni şifre oluşturun".localized(),
                    text: $viewModel.newPassword,
                    isSecure: true
                )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Yeni Şifre (Tekrar)".localized())
                    .poppinsFont(size: 14, weight: .medium)

                AppTextField(
                    title: nil,
                    placeholder: "Yeni şifrenizi tekrar girin".localized(),
                    text: $viewModel.confirmPassword,
                    isSecure: true
                )
            }

            if !viewModel.passwordChangeMessage.isEmpty {
                Text(viewModel.passwordChangeMessage)
                    .foregroundColor(AppTheme.Colors.error)
                    .poppinsFont(size: 13, weight: .regular)
                    .multilineTextAlignment(.center)
            }

            PrimaryButton(title: "Kaydet".localized()) {
                viewModel.updatePassword()
            }

            Spacer()
        }
        .padding(AppTheme.Layout.horizontalPadding)
        .navigationTitle("Şifre Değiştir".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
}
