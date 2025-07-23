//
//  SplashViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import Foundation
import Combine

class SplashViewModel: ObservableObject {
    @Published var isActive = false

    init() {
        startTimer()
    }

    private func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isActive = true
        }
    }
}
