//
//  ProfileView.swift
//  moviesList
//
//  Created by Vera Nur on 14.07.2025.
//

import SwiftUI

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
}


