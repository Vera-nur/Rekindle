//
//  NewPostView.swift
//  Rekindle
//
//  Created by Vera Nur on 24.07.2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import PhotosUI
import Firebase


struct NewPostView: View {
    @StateObject private var viewModel = NewPostViewModel()
    @State private var isPickerPresented = false
    @State private var pickerItem: PhotosPickerItem?
    @State private var isUploading = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // FOTOĞRAF GÖSTERİMİ / YER TUTUCU
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        .frame(height: 250)
                        .background(Color.gray.opacity(0.1))
                    
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Text("Henüz fotoğraf seçilmedi")
                            .foregroundColor(.gray)
                            .poppinsFont(size: 14, weight: .regular)
                    }
                }

                // FOTOĞRAF SEÇ BUTONU
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Text("📷 Fotoğraf Seç")
                        .poppinsFont(size: 16, weight: .semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
                .onChange(of: pickerItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            viewModel.selectedImage = uiImage
                        }
                    }
                }

                // AÇIKLAMA ALANI
                VStack(alignment: .leading, spacing: 4) {
                    Text("Açıklama")
                        .poppinsFont(size: 14, weight: .semibold)
                    TextField("Gönderinize bir açıklama ekleyin...", text: $viewModel.caption)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                // HERKESE AÇIK TOGGLE
                Toggle(isOn: $viewModel.isPublic) {
                    Text("Herkese açık paylaş")
                        .poppinsFont(size: 14, weight: .medium)
                }
                .padding(.horizontal)

                // PAYLAŞ BUTONU
                if isUploading {
                    ProgressView("Paylaşılıyor...")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                } else {
                    Button(action: {
                        isUploading = true
                        viewModel.uploadPost { success in
                            isUploading = false
                            if success {
                                viewModel.caption = ""
                                viewModel.selectedImage = nil
                                dismiss()
                            }
                        }
                    }) {
                        Text("Paylaş")
                            .poppinsFont(size: 16, weight: .semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Yeni Gönderi")
        .navigationBarTitleDisplayMode(.inline)
    }
}
