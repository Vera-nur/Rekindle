//
//  Theme.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI

struct AppTheme {

    struct Colors {
        static let primary = Color("PrimaryColor")
        static let secondary = Color("SecondaryColor")
        static let background = Color(.systemBackground)
        static let textPrimary = Color.primary
        static let textSecondary = Color.gray
        static let fieldBackground = Color(.systemGray6)
        static let error = Color.red
    }

    struct Fonts {
        static let heading = Font.poppins(size: 20, weight: .semibold)
        static let subheading = Font.poppins(size: 16, weight: .medium)
        static let body = Font.poppins(size: 14, weight: .regular)
        static let small = Font.poppins(size: 12, weight: .light)
    }

    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
        static let textFieldHeight: CGFloat = 48
    }
}
