//
//  ProfileView.swift
//  moviesList
//
//  Created by Vera Nur on 14.07.2025.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct ProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true

    @State private var selectedTab = 0
    @State private var showLogoutAlert = false
    var isCurrentUser: Bool

    var body: some View {
        NavigationView {
            VStack {
                // Profil Fotoğrafı ve Kullanıcı Adı
                HStack(alignment: .center, spacing: 16) {
                    AvatarView(image: nil, imageUrl: viewModel.profileImageUrl, size: 80)

                    Text(viewModel.username)
                        .poppinsFont(size: 24, weight: .semibold)
                }
                .padding(.horizontal)

                // 🔒 Sadece kendi profilinde görünür
                if isCurrentUser {
                    NavigationLink(destination: EditProfileView()) {
                        Text("Profili Düzenle")
                            .poppinsFont(size: 16, weight: .medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray5))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }

                // Sekme: Anılar (ve Beğenilenler sadece kendi profilinde)
                Picker("", selection: $selectedTab) {
                    Text("Anılarım").tag(0)
                    if isCurrentUser {
                        Text("Beğenilenler").tag(1)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if selectedTab == 0 {
                    if let userId = viewModel.userId {
                        UserPostGridView(userId: userId)
                    } else {
                        ProgressView()
                    }
                } else if isCurrentUser && selectedTab == 1 {
                    if let userId = viewModel.userId {
                        LikedPostGridView(userId: userId)
                    } else {
                        ProgressView()
                    }
                }

                Spacer()
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isCurrentUser {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .alert("Çıkış yapmak istiyor musunuz?", isPresented: $showLogoutAlert) {
                Button("Evet", role: .destructive) {
                    authViewModel.logout()
                }
                Button("Hayır", role: .cancel) {}
            }
            .onAppear {
                viewModel.fetchUserInfo()
            }
        }
    }
}
