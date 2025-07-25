//
//  ProfileView.swift
//  moviesList
//
//  Created by Vera Nur on 14.07.2025.
//

/*import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var isShowing: Bool
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.fullName)
                    .poppinsFont(size: 18, weight: .semibold)
                Text(viewModel.email)
                    .poppinsFont(size: 14)
                    .foregroundColor(.gray)
            }
            
            Divider()
            
            Button("Edit Profile".localized()) {
                isEditing = true
            }
            .foregroundColor(.blue)
            .poppinsFont(size: 16, weight: .medium)
            
            Button("Logout".localized(), role: .destructive) {
                authViewModel.logout()
                isShowing = false
                
            }
            .poppinsFont(size: 16, weight: .medium)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(maxWidth: 250)
        .sheet(isPresented: $isEditing){
            EditProfileView(viewModel: viewModel)
        }
    }
}*/

import SwiftUI
import Kingfisher
import FirebaseAuth

struct ProfileView: View {
    @State private var posts: [Post] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(posts) { post in
                        VStack(alignment: .leading, spacing: 8) {
                            if let urlString = post.imageUrl, let url = URL(string: urlString) {
                                        KFImage(url)
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(10)
                                    } else {
                                        Text("Görsel bulunamadı")
                                            .foregroundColor(.gray)
                                            .italic()
                                    }

                            if let caption = post.caption {
                                Text(caption)
                                    .font(.body)
                            } else {
                                Text("Açıklama yok.")
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Profilim")
        }
        .onAppear {
            if let uid = Auth.auth().currentUser?.uid {
                    PostService.fetchUserPosts(userId: uid) { fetched in
                        print("Kaç post geldi: \(fetched.count)")
                        for post in fetched {
                            print("Post caption: \(post.caption)")
                        }
                        self.posts = fetched
                    }
                }
        }
    }
}


