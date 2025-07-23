//
//  OnboardingViewModel.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0

    let pages = [
        OnboardingPage(title: "Anılarını Sakla", subtitle: "Özel anılarını güvenle kaydet.", imageName: "memory_icon"),
        OnboardingPage(title: "Kolayca Düzenle", subtitle: "Kategorilere ayır, notlar ekle.", imageName: "organize_icon"),
        OnboardingPage(title: "Yıllar Sonra Hatırla", subtitle: "Geçmişe bir pencere aç.", imageName: "recall_icon")
    ]

    var isLastPage: Bool {
        return currentPage == pages.count - 1
    }

    func nextPage() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        }
    }
}
