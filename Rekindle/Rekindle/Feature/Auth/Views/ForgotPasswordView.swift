//
//  ForgetPassword.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var message: String?
    @State private var showResetAlert = false

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 10)

            Text("Reset Your Password".localized())
                .poppinsFont(size: 20, weight: .semibold)
                .padding(.top, 4)

            Text("Enter your email address and we’ll send you a link to reset your password.".localized())
                .poppinsFont(size: 14)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            AppTextField(
                title: "Email".localized(),
                placeholder: "you@example.com",
                text: $email,
                keyboardType: .emailAddress,
                icon: "envelope"
            )

            PrimaryButton(
                title: "Send Reset Email".localized(),
                action: {
                    if email.isEmpty {
                        message = "Please enter your email.".localized()
                        return
                    }
                    viewModel.resetPassword(email: email)
                    showResetAlert = true
                },
                backgroundColor: AppTheme.Colors.primary
            )

            if let message = message {
                Text(message)
                    .foregroundColor(.red)
                    .poppinsFont(size: 12)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Password Reset".localized()),
                message: Text(viewModel.errorMessage ?? "Unknown error occurred.".localized()),
                dismissButton: .default(Text("OK".localized())) {
                    dismiss()
                }
            )
        }
    }
}
