//
//  Poppins.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI

extension Font {
    static func poppins ( size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .bold:
            return .custom("Poppins-Bold" , size: size)
        case .medium:
            return .custom("Poppins-Medium" , size: size)
        case .light:
            return .custom("Poppins-Light" , size: size)
        case .thin:
            return .custom("Poppins-Thin" , size: size)
        case .semibold:
            return .custom("Poppins-SemiBold" , size: size)
        default:
            return .custom("Poppins-Regular" , size: size)
        }
    }
}

extension View {
    func poppinsFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.font(.poppins(size: size, weight: weight))
    }
}

