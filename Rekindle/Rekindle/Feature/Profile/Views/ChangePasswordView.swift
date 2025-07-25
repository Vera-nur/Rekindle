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
        NavigationStack {
            Form {
                Section {
                    SecureField("Current Password".localized(), text: $viewModel.currentPassword).poppinsFont(size: 16)
                    SecureField("New Password".localized(), text: $viewModel.newPassword).poppinsFont(size: 16)
                    SecureField("Confirm New Password".localized(), text: $viewModel.confirmPassword).poppinsFont(size: 16)

                    if !viewModel.passwordChangeMessage.isEmpty {
                        Text(viewModel.passwordChangeMessage)
                            .foregroundColor(.red)
                            .poppinsFont(size: 13)
                    }

                    Button("Save Password".localized()) {
                        viewModel.updatePassword()
                    }
                    .foregroundColor(.blue)
                    .poppinsFont(size: 16, weight: .semibold)
                }
            }
            .navigationTitle("Change Password".localized())
            }
        }
    }

