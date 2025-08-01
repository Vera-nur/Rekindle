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
import FirebaseDatabase

class NewPostViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var caption: String = ""
    @Published var isPublic: Bool = true
    
    @Published var selectedTrack: Audius.Track?
    
    func uploadPost(completion: @escaping (Bool) -> Void) {
        guard let imageData = selectedImage?.jpegData(compressionQuality: 0.8),
              let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        let filename = UUID().uuidString
        let storage = Storage.storage(url: "gs://iosmobile-e3c42.firebasestorage.app")
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

                // ✅ KULLANICI BİLGİLERİNİ ÇEK
                let ref = Database.database().reference()
                let userRef = ref.child("users").child(userId)

                userRef.observeSingleEvent(of: .value) { snapshot in
                    guard let data = snapshot.value as? [String: Any] else {
                        print("❌ Kullanıcı bilgisi alınamadı (Realtime Database).")
                        completion(false)
                        return
                    }

                    let username = data["username"] as? String ?? "Bilinmeyen"
                    let profileImageUrl = data["profileImageUrl"] as? String ?? ""

                    // 🔥 POST VERİSİ
                    
                    var postData: [String: Any] = [
                        "imageUrl": imageUrl,
                        "caption": self.caption,
                        "timestamp": Timestamp(),
                        "userId": userId,
                        "isPublic": self.isPublic,
                        "username": username,
                        "profileImageUrl": profileImageUrl
                    ]
                    
                    if let track = self.selectedTrack {
                      postData["trackId"]          = track.id
                      postData["trackTitle"]       = track.title
                      postData["trackArtist"]      = track.user.name
                      postData["trackArtworkUrl"]  = track.artwork?.small?.absoluteString ?? ""
                    }
                    
                    

                    Firestore.firestore().collection("posts").addDocument(data: postData) { error in
                        if let error = error {
                            print("📝 Firestore yazım hatası: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("✅ Gönderi başarıyla yüklendi.")
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    
}
