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
                .foregroundColor(.gray.opacity(0.7))

            TextField("", text: $text)
                .padding(12)
                .background(Color(red: 1.0, green: 0.97, blue: 0.90))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
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
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.7))

            SecureField(title, text: $text)
                .padding()
                .background(Color(red: 1.0, green: 0.97, blue: 0.90))
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
        }
    }
}
