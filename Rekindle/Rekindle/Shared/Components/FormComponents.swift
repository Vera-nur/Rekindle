//
//  FormComponents.swift
//  Rekindle
//
//  Created by Vera Nur on 25.07.2025.
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color.black.opacity(0.85))

            TextField("", text: $text)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1.2)
                )
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
}

struct SecureInputField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color.black.opacity(0.85))

            SecureField("", text: $text)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1.2)
                )
        }
    }
}
