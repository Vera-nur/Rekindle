//
//  RegisterView.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var navigateToEditProfile = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        
                        // Başlık
                        Text("Create Your Account".localized())
                            .poppinsFont(size: 26, weight: .bold)
                            .foregroundColor(AppTheme.Colors.primary)
                            .padding(.top, 40)

                        // Form
                        VStack(spacing: 20) {
                            AppTextField(title: nil, placeholder: "First Name".localized(), text: $viewModel.firstName)
                            AppTextField(title: nil, placeholder: "Last Name".localized(), text: $viewModel.lastName)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Birth Date".localized())
                                    .font(.caption)
                                    .foregroundColor(.black.opacity(0.85))
                                DatePicker("", selection: $viewModel.birthDate, displayedComponents: .date)
                                    .labelsHidden()
                                    .datePickerStyle(.compact)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1.2)
                                    )
                            }

                            AppTextField(title: nil, placeholder: "Phone Number".localized(), text: $viewModel.phoneNumber, keyboardType: .phonePad)
                            AppTextField(title: nil, placeholder: "Email".localized(), text: $viewModel.email, keyboardType: .emailAddress)
                            AppTextField(title: nil, placeholder: "Password".localized(), text: $viewModel.password, isSecure: true)

                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                                    .poppinsFont(size: 12)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 5)
                            }
                        }
                        .padding()
                        .background(.white)
                        .cornerRadius(16)
                        .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)

                        // Register Button
                        PrimaryButton(
                            title: "Register".localized(),
                            action: {
                                viewModel.register()
                            },
                            backgroundColor: AppTheme.Colors.primary
                        )
                        .padding(.horizontal)

                        // Back to Login
                        SecondaryButton(
                            title: "Back to Login".localized(),
                            action: {
                                dismiss()
                            },
                            topPadding: 5
                        )

                        Spacer()
                    }
                }
            }
        }
    }
}
