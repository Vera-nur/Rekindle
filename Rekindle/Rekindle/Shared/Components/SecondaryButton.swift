//
//  SecondaryButton.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var textColor: Color = AppTheme.Colors.primary
    var font: Font = .poppins(size: 12)
    var topPadding: CGFloat = 0

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(font)
                .foregroundColor(textColor)
                .padding(.top, topPadding)
        }
    }
}
