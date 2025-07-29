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

    var body: some View {
        VStack {
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
            }

            PhotosPicker(selection: $pickerItem, matching: .images) {
                Text("Fotoğraf Seç")
            }
            .onChange(of: pickerItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        viewModel.selectedImage = uiImage
                    }
                }
            }

            TextField("Açıklama ekle...", text: $viewModel.caption)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            Toggle("Herkese açık paylaş", isOn: $viewModel.isPublic)

            Button("Paylaş") {
                viewModel.uploadPost { success in
                    if success {
                        print("Gönderi başarıyla yüklendi")
                        viewModel.caption = ""
                        viewModel.selectedImage = nil
                    } else {
                        print("Gönderi yüklenemedi")
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}



