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
        let currentPage = viewModel.pages[viewModel.currentPage]

        ZStack {
            currentPage.backgroundColor
                .ignoresSafeArea()

            VStack {
                TabView(selection: $viewModel.currentPage) {
                    ForEach(0..<viewModel.pages.count, id: \.self) { index in
                        let page = viewModel.pages[index]

                        VStack(spacing: 20) {
                            Spacer()

                            Image(page.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 250)
                                .transition(.scale)
                                .animation(.easeInOut, value: viewModel.currentPage)

                            Text(page.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .transition(.opacity)

                            Text(page.subtitle)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)

                            Spacer()
                        }
                        .padding()
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                HStack(spacing: 8) {
                    ForEach(0..<viewModel.pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == viewModel.currentPage ? Color.white : Color.white.opacity(0.4))
                            .frame(width: index == viewModel.currentPage ? 24 : 8, height: 8)
                            .animation(.easeInOut, value: viewModel.currentPage)
                    }
                }
                .padding(.bottom, 10)

                Button(action: {
                    if viewModel.isLastPage {
                        authViewModel.markOnboardingAsSeen()
                    } else {
                        withAnimation {
                            viewModel.nextPage()
                        }
                    }
                }) {
                    Text(viewModel.isLastPage ? "Keşfetmeye Başla" : "Devam Et")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(currentPage.backgroundColor)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                if viewModel.currentPage > 0 {
                    Button("Geri Dön") {
                        withAnimation {
                            viewModel.currentPage -= 1
                        }
                    }
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 5)
                }
            }
        }
    }
}
