//
//  EditProfileView.swift
//  moviesList
//
//  Created by Vera Nur on 16.07.2025.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isShowingPasswordView = false
    

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name".localized()).poppinsFont(size: 14, weight: .semibold)) {
                    TextField("First Name".localized(), text: $viewModel.firstName).poppinsFont(size: 16)
                    TextField("Last Name".localized(), text: $viewModel.lastName).poppinsFont(size: 16)
                }

                Section(header: Text("Phone Number".localized()).poppinsFont(size: 14, weight: .semibold)) {
                    TextField("Phone".localized(), text: $viewModel.phoneNumber)
                        .keyboardType(.phonePad)
                        .poppinsFont(size: 16)
                }

                Section(header: Text("Birth Date".localized()).poppinsFont(size: 14, weight: .semibold)) {
                    DatePicker("Birth Date".localized(), selection: $viewModel.birthDate, displayedComponents: .date)
                        .poppinsFont(size: 16)
                }

                Section {
                    Button("Save Changes".localized()) {
                        viewModel.updateProfile()
                        dismiss()
                    }
                    .poppinsFont(size: 16, weight: .semibold)
                }
                Section(header: Text("Account Security".localized()).poppinsFont(size: 14, weight: .semibold)) {
                    Button("Change Password".localized()) {
                        isShowingPasswordView = true
                    }
                    .foregroundColor(.blue)
                    .poppinsFont(size: 16)
                }
            }
            .navigationTitle("Edit Profile".localized())
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchUserInfo()
            }
            .sheet(isPresented: $isShowingPasswordView){
                    ChangePasswordView(viewModel: viewModel)
            }
        }
    }
}

