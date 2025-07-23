//
//  UserProfileViewModel.swift
//  moviesList
//
//  Created by Vera Nur on 14.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class UserProfileViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var fullName: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var birthDate: Date = Date()
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var passwordChangeMessage: String = ""
    @Published var newEmail: String = ""
    @Published var emailChangeMessage: String = ""


    init() {
        fetchUserInfo()
    }

    func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        self.email = user.email ?? ""

        let ref = Database.database().reference()
        ref.child("users").child(user.uid).observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any] {
                DispatchQueue.main.async {
                    self.firstName = data["firstName"] as? String ?? ""
                    self.lastName = data["lastName"] as? String ?? ""
                    self.phoneNumber = data["phoneNumber"] as? String ?? ""
                    if let birthDateString = data["birthDate"] as? String {
                        let formatter = ISO8601DateFormatter()
                        if let date = formatter.date(from: birthDateString) {
                            self.birthDate = date
                        }
                    }
                    self.fullName = "\(self.firstName) \(self.lastName)"
                }
            }
        }
    }

    func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }

        let ref = Database.database().reference()
        let formatter = ISO8601DateFormatter()
        let birthDateString = formatter.string(from: self.birthDate)
        
        let userRef = ref.child("users").child(user.uid)

        let updatedData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "birthDate": birthDateString
        ]

        userRef.updateChildValues(updatedData) { error, _ in
            if let error = error {
                print("Update failed: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.fullName = "\(self.firstName) \(self.lastName)"
                }
                print("Profile updated successfully.")
            }
        }
    }
    func updatePassword() {
            guard let user = Auth.auth().currentUser,
                  let email = user.email else {
                passwordChangeMessage = "User not authenticated"
                return
            }

            guard newPassword == confirmPassword else {
                passwordChangeMessage = "New passwords do not match"
                return
            }

            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

            user.reauthenticate(with: credential) { _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.passwordChangeMessage = "Current password incorrect: \(error.localizedDescription)"
                    }
                } else {
                    user.updatePassword(to: self.newPassword) { error in
                        DispatchQueue.main.async {
                            if let error = error {
                                self.passwordChangeMessage = "Error: \(error.localizedDescription)"
                            } else {
                                self.passwordChangeMessage = "Password updated successfully ✅"
                                self.currentPassword = ""
                                self.newPassword = ""
                                self.confirmPassword = ""
                            }
                        }
                    }
                }
            }
        }
}
