//
//  PostCardViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 25.07.2025.
//

import Foundation
import AVFoundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class PostCardViewModel: ObservableObject {
    let post: Post
    let showMenu: Bool

    @Published var caption: String
    @Published var isEditingCaption = false
    @Published var showSuccessMessage = false
    @Published var isLiked: Bool = false

    @Published var isPlayingAudio = false
     var player: AVPlayer?
     var playbackTimer: Timer?

    private let postId: String
    private let userId: String

    init(post: Post, showMenu: Bool = false) {
        self.post       = post
        self.showMenu   = showMenu
        self.caption    = post.caption ?? ""
        self.postId     = post.id ?? ""
        self.userId     = Auth.auth().currentUser?.uid ?? ""
        checkIfLiked()
    }


    func checkIfLiked() {
        guard !userId.isEmpty else { return }
        let docRef = Firestore.firestore()
            .collection("posts")
            .document(postId)
            .collection("likes")
            .document(userId)

        docRef.getDocument { snapshot, _ in
            DispatchQueue.main.async {
                self.isLiked = snapshot?.exists == true
            }
        }
    }

    func toggleLike() {
        guard !userId.isEmpty else { return }
        let likesRef = Firestore.firestore()
            .collection("posts")
            .document(postId)
            .collection("likes")
            .document(userId)

        if isLiked {
            likesRef.delete { _ in self.isLiked = false }
        } else {
            likesRef.setData(["likedAt": Timestamp()]) { _ in self.isLiked = true }
        }
    }



    func startEditingCaption() {
        isEditingCaption = true
    }

    func saveCaption(_ newCaption: String, completion: @escaping (Bool) -> Void) {
        let ref = Firestore.firestore().collection("posts").document(postId)
        ref.updateData(["caption": newCaption]) { error in
            DispatchQueue.main.async {
                guard error == nil else { return completion(false) }
                // Hem VM’deki caption’ı güncelle, hem UI state’ini resetle
                self.caption           = newCaption
                self.showSuccessMessage = true
                self.isEditingCaption   = false
                // Başarı mesajını 2 sn sonra gizle
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showSuccessMessage = false
                }
                completion(true)
            }
        }
    }


    func deletePost(completion: @escaping () -> Void) {
        let db      = Firestore.firestore()
        let storage = Storage.storage()
        let postRef = db.collection("posts").document(postId)

        postRef.getDocument { snapshot, error in
            let data     = snapshot?.data() ?? [:]
            let imageUrl = data["imageUrl"] as? String

            let deleteDoc = {
                postRef.delete { _ in completion() }
            }

            if let imageUrl = imageUrl {
                storage.reference(forURL: imageUrl).delete { _ in
                    deleteDoc()
                }
            } else {
                deleteDoc()
            }
        }
    }
    

    func initializeAudio() {
        guard let trackId = post.trackId else { return }
        configureAudioSession()

        let urlString = "https://discoveryprovider.audius.co/v1/tracks/\(trackId)/stream?app_name=rekindle"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
        }
    }

    func toggleAudio() {
        guard let player = player else { return }

        if isPlayingAudio {
            stopAudio()
        } else {
            startAudio()
        }
    }

    private func startAudio() {
        guard let player = player else { return }

        if let dur = player.currentItem?.asset.duration.seconds, dur.isFinite {
            let mid = dur / 2
            player.seek(to: CMTime(seconds: mid, preferredTimescale: 600))
        }

        player.play()
        isPlayingAudio = true

        playbackTimer?.invalidate()
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { _ in
            self.stopAudio()
        }
    }

    private func stopAudio() {
        player?.pause()
        isPlayingAudio = false
        playbackTimer?.invalidate()
        playbackTimer = nil
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance()
                .setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("🔊 AudioSession failed:", error)
        }
    }
}
