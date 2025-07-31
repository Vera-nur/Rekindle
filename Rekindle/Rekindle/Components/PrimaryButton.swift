//
//  PrimaryButton.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var backgroundColor: Color = .blue
    var textColor: Color = .white
    var cornerRadius: CGFloat = 12
    var horizontalPadding: CGFloat = 16
    var verticalPadding: CGFloat = 12
    var font: Font = .headline

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(textColor)
                .font(font)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        }
    }
}
