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
import Kingfisher

struct NewPostView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = NewPostViewModel()
    @State private var showLocationPicker = false
    @State private var pickerItem: PhotosPickerItem?
    @State private var isUploading = false
    @Environment(\.dismiss) var dismiss
    
    @State private var showMusicSheet = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                PostImagePlaceholder(image: viewModel.selectedImage)

                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Text("📷 Fotoğraf Seç".localized())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .font(AppTheme.Fonts.subheading)
                }
                .onChange(of: pickerItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            viewModel.selectedImage = uiImage
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Açıklama".localized())
                        .poppinsFont(size: 14, weight: .semibold)

                    AppTextField(
                        title: nil,
                        placeholder: "Gönderinize bir açıklama ekleyin...".localized(),
                        text: $viewModel.caption
                    )
                }
                
                Button {
                  showMusicSheet = true
                } label: {
                  HStack {
                    Image(systemName: "music.note.list")
                      Text(viewModel.selectedTrack?.title ?? "Şarkı Ekle".localized())
                      .lineLimit(1)
                    Spacer()
                    if viewModel.selectedTrack != nil {
                      Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    }
                  }
                  .padding()
                  .background(Color.secondary.opacity(0.2))
                  .cornerRadius(12)
                }
                .sheet(isPresented: $showMusicSheet) {
                  TrackSearchView(selectedTrack: $viewModel.selectedTrack)
                }
                
                VStack(alignment: .leading) {
                  Text("Konum").font(.subheadline).bold()
                  if let loc = viewModel.locationName {
                    HStack {
                      Image(systemName: "mappin.and.ellipse")
                      Text(loc)
                    }
                  } else {
                    Button("Konum Ekle") {
                        viewModel.requestLocation()
                    }
                  }
                }

                Toggle(isOn: $viewModel.isPublic) {
                    Text("Herkese açık paylaş".localized())
                        .poppinsFont(size: 14, weight: .medium)
                }
                .padding(.horizontal)

                if isUploading {
                    ProgressView("Paylaşılıyor...".localized())
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.Colors.primary.opacity(0.1))
                        .cornerRadius(12)
                } else {
                    PrimaryButton(title: "Paylaş".localized()) {
                        isUploading = true
                        viewModel.uploadPost { success in
                            isUploading = false
                            if success {
                                viewModel.caption = ""
                                viewModel.selectedImage = nil
                                viewModel.selectedTrack = nil
                                dismiss()
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Yeni Gönderi".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
}
