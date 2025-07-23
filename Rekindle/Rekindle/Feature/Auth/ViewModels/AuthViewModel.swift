//
//  AuthViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import Foundation
import FirebaseAuth
import Firebase


class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    init() {
        observeAuthState()
    }

    private func observeAuthState() {
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                if let user = user {
                    self.email = user.email ?? ""
                    self.isAuthenticated = true
                } else {
                    self.isAuthenticated = false
                }
            }
        }
    }
    

    func login() {
        AuthManager.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isAuthenticated = true
                case .failure(let error as NSError):
                    switch AuthErrorCode(rawValue: error.code) {
                    case .wrongPassword:
                        self.errorMessage = "Incorrect password. Please try again."
                    case .invalidEmail:
                        self.errorMessage = "Invalid email format."
                    case .userNotFound:
                        self.errorMessage = "No user found with this email."
                    case .userDisabled:
                        self.errorMessage = "This user account has been disabled."
                    case .networkError:
                        self.errorMessage = "Network error. Check your connection."
                    default:
                        self.errorMessage = "Login failed: \(error.localizedDescription)"
                    }
                default:
                    self.errorMessage = "An unknown error occurred."
                }
            }
        }
    }

    func register() {
        AuthManager.shared.register(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isAuthenticated = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func logout() {
        do {
            try AuthManager.shared.logout()
            DispatchQueue.main.async {
                self.email = ""
                self.password = ""
                self.errorMessage = nil
                self.isAuthenticated = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func resetPassword(email: String) {
        guard !email.isEmpty else {
            self.errorMessage = "Please enter your email to reset password."
            return
        }

        AuthManager.shared.sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Reset failed: \(error.localizedDescription)"
                } else {
                    self.errorMessage = "Password reset email sent. Please check your inbox."
                }
            }
        }
    }
}
