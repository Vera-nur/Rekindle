//
//  NewPostViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 24.07.2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import PhotosUI
import Firebase

class NewPostViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var caption: String = ""
    @Published var isPublic: Bool = true

    func uploadPost(completion: @escaping (Bool) -> Void) {
        guard let imageData = selectedImage?.jpegData(compressionQuality: 0.8),
              let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        let filename = UUID().uuidString
        let storage = Storage.storage(url: "gs://iosmobile-e3c42.appspot.com")
        let storageRef = storage.reference().child("posts/\(filename).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("📦 Storage upload error: \(error.localizedDescription)")
                completion(false)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("🔗 URL fetch error: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let imageUrl = url?.absoluteString else {
                    print("❌ Image URL is nil")
                    completion(false)
                    return
                }

                let postData: [String: Any] = [
                    "imageUrl": imageUrl,
                    "caption": self.caption,
                    "timestamp": Timestamp(),
                    "userId": userId,
                    "isPublic": self.isPublic
                ]

                Firestore.firestore().collection("posts").addDocument(data: postData) { error in
                    if let error = error {
                        print("📝 Firestore write error: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("✅ Post uploaded successfully.")
                        completion(true)
                    }
                }
            }
        }
    }
}
