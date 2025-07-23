//
//  OnboardingView.swift
//  Rekindle
//
//  Created by Vera Nur on 23.07.2025.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<viewModel.pages.count, id: \.self) { index in
                    let page = viewModel.pages[index]
                    VStack(spacing: 20) {
                        Image(page.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        Text(page.title)
                            .font(.title)
                            .bold()
                        Text(page.subtitle)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())

            Button(action: {
                if viewModel.isLastPage {
                    authViewModel.markOnboardingAsSeen()
                } else {
                    viewModel.nextPage()
                }
            }) {
                Text(viewModel.isLastPage ? "Başla" : "İleri")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
            }
        }
    }
}
