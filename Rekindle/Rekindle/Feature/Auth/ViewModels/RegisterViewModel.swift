//
//  RegisterViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var birthDate: Date = Date()
    @Published var phoneNumber: String = ""
    @Published var errorMessage: String?
    @Published var registrationSuccess: Bool = false

    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            } else if let user = result?.user {
                self.saveUserInfo(uid: user.uid)
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
}
