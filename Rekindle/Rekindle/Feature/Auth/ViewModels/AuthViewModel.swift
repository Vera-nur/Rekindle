//
//  AuthViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import Foundation
import FirebaseAuth
import Firebase
import SwiftUI


class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isLoading = true
    @Published var hasSeenOnboarding: Bool = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("didCompleteProfile") var didCompleteProfile: Bool = false
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date = Date()
    @Published var phoneNumber: String = ""
    @Published var registrationSuccess: Bool = false
    @Published var didRegisterNewUser: Bool = false
    @Published var showVerificationAlert: Bool = false
    @Published var currentUserId: String? = Auth.auth().currentUser?.uid
    
    init() {
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        observeAuthState()
    }

    private func observeAuthState() {
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                if let user = user {
                    self.email = user.email ?? ""
                    self.currentUserId = user.uid
                    if user.isEmailVerified {
                        self.isAuthenticated = true
                    } else {
                        // Doğrulanmamış kullanıcı otomatik olarak girişli geliyor; doğrulama bekleniyor
                        self.isAuthenticated = false
                        self.errorMessage = "Please verify your email. A verification link was sent." // isteğe bağlı bilgilendirme
                    }
                } else {
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    func checkAuthenticationStatus() {
        isLoading = true
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

        if Auth.auth().currentUser != nil {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.isLoading = false
        }
    }
    
    func markOnboardingAsSeen() {
        hasSeenOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
    

    func login() {
        AuthManager.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let user = Auth.auth().currentUser, user.isEmailVerified {
                        self.isAuthenticated = true
                        self.isLoggedIn = true
                    } else {
                        self.errorMessage = "Please verify your email before logging in."
                        try? Auth.auth().signOut()
                    }
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
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let uid = result?.user.uid else {
                    self.errorMessage = "User ID not found."
                    return
                }

                // E-posta doğrulama
                result?.user.sendEmailVerification(completion: { emailError in
                    if let emailError = emailError {
                        self.errorMessage = "Verification email could not be sent: \(emailError.localizedDescription)"
                        return
                    }
                    
                    self.saveUserInfo(uid: uid)
                    
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        // Sign out başarısızsa bile devam et
                    }

                    self.errorMessage = nil
                    self.isAuthenticated = false
                    self.isLoggedIn = false
                    self.didRegisterNewUser = true 
                    self.registrationSuccess = true
                    self.showVerificationAlert = true
                    self.didCompleteProfile = false

                    
                })
            }
        }
    }
    
    private func saveUserInfo(uid: String) {
        let ref = Database.database().reference()
        let userInfo: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "birthDate": ISO8601DateFormatter().string(from: birthDate),
            "phoneNumber": phoneNumber
        ]

        ref.child("users").child(uid).setValue(userInfo) { error, _ in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to save user info: \(error.localizedDescription)"
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = nil
                    self.registrationSuccess = true
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
                self.isLoggedIn = false
                self.didRegisterNewUser = false
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
