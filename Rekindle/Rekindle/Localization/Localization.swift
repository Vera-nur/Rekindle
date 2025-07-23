//
//  Localization.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import Foundation

extension String {
    public func localized(with arg: [CVarArg] = []) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arg)
    }
}
