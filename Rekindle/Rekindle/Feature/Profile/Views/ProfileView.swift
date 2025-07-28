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
    @EnvironmentObject var authViewModel: AuthViewModel // ✅ EKLENDİ
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true

    @State private var selectedTab = 0
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationView {
            VStack {
                // Profil Fotoğrafı ve Kullanıcı Adı
                HStack(alignment: .center, spacing: 16) {
                    if let urlString = viewModel.profileImageUrl,
                       let url = URL(string: urlString) {
                        KFImage(url)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                    }

                    Text(viewModel.username)
                        .poppinsFont(size: 24, weight: .semibold)
                }
                .padding(.horizontal)

                // Profili Düzenle Butonu
                NavigationLink(destination: EditProfileView()) {
                    Text("Profili Düzenle")
                        .poppinsFont(size: 16, weight: .medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                // Alt Kısım: TabView
                Picker("", selection: $selectedTab) {
                    Text("Anılarım").tag(0)
                    Text("Beğenilenler").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if selectedTab == 0 {
                    if let userId = viewModel.userId {
                        UserPostGridView(userId: userId)
                    } else {
                        ProgressView()
                    }
                } else {
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Çıkış yapmak istiyor musunuz?", isPresented: $showLogoutAlert) {
                Button("Evet", role: .destructive) {
                    authViewModel.logout() // ✅ DEĞİŞTİRİLDİ
                }
                Button("Hayır", role: .cancel) {}
            }
            .onAppear {
                viewModel.fetchUserInfo()
            }
        }
    }
}
