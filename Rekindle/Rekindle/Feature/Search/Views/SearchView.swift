//
//  SearchView.swift
//  Rekindle
//
//  Created by Vera Nur on 24.07.2025.
//
import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
            VStack {
                TextField("Kullanıcı adı ara", text: $viewModel.searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: viewModel.searchText) { _ in
                        viewModel.searchUsers()
                    }
                
                List(viewModel.users.filter { $0.id != authViewModel.currentUserId }) { user in
                    NavigationLink(
                        destination: ProfileView(
                            viewModel: UserProfileViewModel(userId: user.id), isCurrentUser: false
                        )
                    ) {
                        UserRowView(user: user)
                    }
                }
                .listStyle(PlainListStyle())
            }
        .navigationTitle("Kullanıcı Ara")
    }
}
