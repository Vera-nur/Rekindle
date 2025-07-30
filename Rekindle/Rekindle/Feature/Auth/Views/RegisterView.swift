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
                VStack(spacing: 20) {
                    Text("Create Your Account".localized())
                        .poppinsFont(size: 20, weight: .semibold)
                        .foregroundColor(.white)
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
                    .background(Color("OnboardingPeach"))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Button(action: {
                        viewModel.register()
                    }) {
                        Text("Register".localized())
                            .poppinsFont(size: 16, weight: .semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("OnboardingBlue"))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Button("Back to Login".localized()) {
                        dismiss()
                    }
                    .poppinsFont(size: 12)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    
                    Spacer()
                }
                .onChange(of: viewModel.registrationSuccess) {
                    if viewModel.registrationSuccess {
                        navigateToEditProfile = true
                    }
                }
                NavigationLink(value: "editProfile") {
                    EmptyView()
                }
                .navigationDestination(for: String.self) { value in
                    if value == "editProfile" {
                        EditProfileView()
                    }
                }.alert("Verification Email Sent", isPresented: $viewModel.showVerificationAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("A verification email has been sent to your address. Please verify before logging in.")
                }
        }
    }
}
