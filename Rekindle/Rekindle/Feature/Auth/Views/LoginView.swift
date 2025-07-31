//
//  LoginView.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isShowingRegister = false
    @State private var isShowingResetPassword = false

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Welcome".localized())
                .poppinsFont(size: 24, weight: .semibold)
            
            AppTextField(
                title: "Email".localized(),
                placeholder: "you@example.com",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                icon: "envelope"
            )
            
            AppTextField(
                title: "Password".localized(),
                placeholder: "••••••••",
                text: $viewModel.password,
                isSecure: true,
                icon: "lock"
            )
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(AppTheme.Colors.error)
                    .poppinsFont(size: 12)
            }

            PrimaryButton(
                title: "Login".localized(),
                action: {
                    viewModel.login()
                },
                backgroundColor: AppTheme.Colors.primary
            )
            
            SecondaryButton(
                title: "Forgot password?".localized(),
                action: {
                    isShowingResetPassword = true
                }
            )
            .sheet(isPresented: $isShowingResetPassword) {
                ForgotPasswordView()
                    .presentationDetents([.fraction(0.35)])
                    .presentationDragIndicator(.visible)
            }

            
            SecondaryButton(
                title: "Don't have an account? Register".localized(),
                action: {
                    isShowingRegister = true
                },
                topPadding: 5
            )
            
            Spacer()
        }
        .padding()
        .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
            ContentView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $isShowingRegister) {
            RegisterView()
                .environmentObject(viewModel)
        }
    }
}
