//
//  UserSearchViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 29.07.2025.
//

import Foundation
import FirebaseDatabase

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var users: [User] = []

    func searchUsers() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            self.users = []
            return
        }

        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var matchedUsers: [User] = []

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dict = childSnapshot.value as? [String: Any],
                   let username = dict["username"] as? String,
                   username.lowercased().contains(trimmed.lowercased()) {

                    let firstName = dict["firstName"] as? String ?? ""
                    let lastName = dict["lastName"] as? String ?? ""
                    let fullName = "\(firstName) \(lastName)"

                    let user = User(
                        id: childSnapshot.key,
                        email: dict["email"] as? String ?? "",
                        fullName: fullName,
                        username: username,
                        profileImageUrl: dict["profileImageUrl"] as? String
                    )

                    matchedUsers.append(user)
                }
            }

            DispatchQueue.main.async {
                self.users = matchedUsers
            }
        })
    }
}
