//
//  UserProfileViewModel.swift
//  moviesList
//
//  Created by Vera Nur on 14.07.2025.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SwiftUI

class UserProfileViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var fullName: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var birthDate: Date = Date()
    @Published var username: String = ""
    @Published var userId: String?
    @Published var profileImageUrl: String?
    @Published var selectedImage: UIImage?

    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var passwordChangeMessage: String = ""
    
    init() {
        fetchUserInfo()
    }

    func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else { return }
        self.userId = user.uid
        self.email = user.email ?? ""
        
        let ref = Database.database().reference().child("users").child(user.uid)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else { return }

            DispatchQueue.main.async {
                self.firstName = data["firstName"] as? String ?? ""
                self.lastName = data["lastName"] as? String ?? ""
                self.username = data["username"] as? String ?? ""
                self.profileImageUrl = data["profileImageUrl"] as? String
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

    func updateProfile(completion: @escaping (Bool) -> Void = { _ in }) {
        guard let user = Auth.auth().currentUser else { return }
        let ref = Database.database().reference().child("users").child(user.uid)
        
        let formatter = ISO8601DateFormatter()
        let birthDateString = formatter.string(from: self.birthDate)
        
        var updatedData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "phoneNumber": phoneNumber,
            "birthDate": birthDateString
        ]

        // Profil resmi seçildiyse önce Firebase Storage'a yükle
        if let image = selectedImage {
            uploadProfileImage(image) { url in
                if let url = url {
                    updatedData["profileImageUrl"] = url.absoluteString
                    self.profileImageUrl = url.absoluteString
                }

                ref.updateChildValues(updatedData) { error, _ in
                    DispatchQueue.main.async {
                        completion(error == nil)
                    }
                }
            }
        } else {
            ref.updateChildValues(updatedData) { error, _ in
                DispatchQueue.main.async {
                    completion(error == nil)
                }
            }
        }
    }

    private func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("profile_images/\(uid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }

        storageRef.putData(imageData, metadata: nil) { _, error in
            if error != nil {
                completion(nil)
                return
            }

            storageRef.downloadURL { url, _ in
                completion(url)
            }
        }
    }

    func updatePassword() {
        guard let user = Auth.auth().currentUser, let email = user.email else {
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
