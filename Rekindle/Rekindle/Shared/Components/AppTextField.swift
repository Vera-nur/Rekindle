//
//  AppTextField.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI

struct AppTextField: View {
    let title: String?
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var icon: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let title = title {
                Text(title)
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textPrimary.opacity(0.85))
            }

            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                }

                if isSecure {
                    SecureField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .padding()
            .frame(height: AppTheme.Layout.textFieldHeight)
            .background(AppTheme.Colors.fieldBackground)
            .cornerRadius(AppTheme.Layout.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Layout.cornerRadius)
                    .stroke(AppTheme.Colors.textSecondary.opacity(0.4), lineWidth: 1.2)
            )
        }
    }
}
