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
                Color(.systemGray6).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 30) {
                        // Başlık
                        Text("Create Your Account".localized())
                            .poppinsFont(size: 26, weight: .bold)
                            .foregroundColor(Color("Blue"))
                            .padding(.top, 40)

                        // Form
                        VStack(spacing: 20) {
                            CustomTextField(title: "First Name".localized(), text: $viewModel.firstName)
                            CustomTextField(title: "Last Name".localized(), text: $viewModel.lastName)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Birth Date".localized())
                                    .font(.caption)
                                    .foregroundColor(Color.black.opacity(0.85))
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

                            CustomTextField(title: "Phone Number".localized(), text: $viewModel.phoneNumber, keyboardType: .phonePad)
                            CustomTextField(title: "Email".localized(), text: $viewModel.email, keyboardType: .emailAddress)
                            SecureInputField(title: "Password".localized(), text: $viewModel.password)

                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                                    .poppinsFont(size: 12)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 5)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)

                        // Register Butonu
                        Button(action: {
                            viewModel.register()
                        }) {
                            Text("Register".localized())
                                .poppinsFont(size: 16, weight: .semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("Blue"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: Color("Blue").opacity(0.3), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal)

                        // Geri Dön
                        Button("Back to Login".localized()) {
                            dismiss()
                        }
                        .poppinsFont(size: 12)
                        .foregroundColor(Color("Blue"))
                        .padding(.top, 5)

                        Spacer()
                    }
                }
            }
        }
    }
}
