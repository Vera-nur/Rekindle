//
//  RegisterView.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Your Account".localized())
                .poppinsFont(size: 20, weight: .semibold)
                .padding(.top, 40)

            VStack(spacing: 15) {
                Group {
                    CustomTextField(title: "First Name".localized(), text: $viewModel.firstName)
                    CustomTextField(title: "Last Name".localized(), text: $viewModel.lastName)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Birth Date".localized())
                            .poppinsFont(size: 14)
                            .foregroundColor(.gray)
                        DatePicker("", selection: $viewModel.birthDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                    }

                    CustomTextField(title: "Phone Number".localized(), text: $viewModel.phoneNumber, keyboardType: .phonePad)
                    CustomTextField(title: "Email".localized(), text: $viewModel.email, keyboardType: .emailAddress)
                    SecureInputField(title: "Password".localized(), text: $viewModel.password)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .poppinsFont(size: 12)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)

            Button(action: {
                viewModel.register()
            }) {
                Text("Register".localized())
                    .poppinsFont(size: 16, weight: .semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)

            Button("Back to Login".localized()) {
                dismiss()
            }
            .poppinsFont(size: 12)
            .padding(.top, 5)

            Spacer()
        }
        .onChange(of: viewModel.registrationSuccess) { success in
            if success {
                dismiss()
            }
        }
    }
}
