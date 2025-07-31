//
//  EditProfileView.swift
//  moviesList
//
//  Created by Vera Nur on 16.07.2025.
//
import SwiftUI
import PhotosUI
import FirebaseAuth
import Kingfisher

struct EditProfileView: View {
    @StateObject private var viewModel: UserProfileViewModel
    @State private var showImagePicker = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) var dismiss
    @AppStorage("didCompleteProfile") var didCompleteProfile: Bool = false
    @State private var isSaving = false
    
    
    init() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        _viewModel = StateObject(wrappedValue: UserProfileViewModel(userId: uid))
    }
    

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    AvatarView(image: viewModel.selectedImage, imageUrl: viewModel.profileImageUrl, size: 120)

                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("Profil Fotoğrafını Değiştir".localized())
                            .font(.poppins(size: 14, weight: .medium))
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                    .onChange(of: selectedItem) { newItem in
                        if let item = newItem {
                            Task {
                                if let data = try? await item.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    viewModel.selectedImage = uiImage
                                }
                            }
                        }
                    }
                }

                AppTextField(title: "Ad".localized(), placeholder: "Adınızı girin".localized(), text: $viewModel.firstName)
                AppTextField(title: "Soyad".localized(), placeholder: "Soyadınızı girin".localized(), text: $viewModel.lastName)
                AppTextField(title: "Kullanıcı Adı".localized(), placeholder: "Kullanıcı adı belirleyin".localized(), text: $viewModel.username)
                AppTextField(title: "Telefon Numarası".localized(), placeholder: "05xxxxxxxxx", text: $viewModel.phoneNumber, keyboardType: .phonePad)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Doğum Tarihi".localized())
                        .font(.poppins(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.Colors.textPrimary)

                    DatePicker("", selection: $viewModel.birthDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }


                PrimaryButton(title: isSaving ? "Kaydediliyor...".localized() : "Kaydet".localized()) {
                    isSaving = true
                    viewModel.updateProfile { success in
                        isSaving = false
                        if success {
                            didCompleteProfile = true
                            showSuccessAlert = true
                        }
                    }
                }
                .disabled(isSaving)

                NavigationLink(destination: ChangePasswordView(viewModel: viewModel)) {
                    Text("Şifreyi Değiştir".localized())
                        .font(.poppins(size: 12))
                        .foregroundColor(AppTheme.Colors.primary)
                        .padding(.top, 8)
                }

            }
            .padding(AppTheme.Layout.horizontalPadding)
        }
        .navigationTitle("Profili Düzenle".localized())
        .navigationBarTitleDisplayMode(.inline)
        .alert("Profiliniz başarıyla güncellendi!".localized(), isPresented: $showSuccessAlert) {
            Button("Tamam".localized()) {
                dismiss()
            }
            Button("Düzenlemeye Devam Et".localized(), role: .cancel) {}
        }
    }
}

