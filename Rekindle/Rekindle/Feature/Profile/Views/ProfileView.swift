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

struct ProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel

    @State private var selectedTab = 0 // 0: Kendi anıları, 1: Beğenilenler

    var body: some View {
        NavigationView{
            VStack {
                // Üst Kısım: Profil Fotoğrafı ve Kullanıcı Adı
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
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchUserInfo()
        }
    }
}

