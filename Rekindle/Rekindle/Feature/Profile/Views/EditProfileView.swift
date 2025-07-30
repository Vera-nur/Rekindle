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
    
    
    init() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        _viewModel = StateObject(wrappedValue: UserProfileViewModel(userId: uid))
    }
    

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Profil Fotoğrafı
                VStack {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    } else if let imageUrl = viewModel.profileImageUrl, let url = URL(string: imageUrl) {
                        KFImage(url)
                            .placeholder {
                                ProgressView()
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }

                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Text("Profil Fotoğrafını Değiştir")
                            .poppinsFont(size: 14, weight: .medium)
                            .foregroundColor(.blue)
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

                // Ad
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ad").poppinsFont(size: 16, weight: .semibold)
                    TextField("Adınızı girin", text: $viewModel.firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .poppinsFont(size: 14)
                }

                // Soyad
                VStack(alignment: .leading, spacing: 4) {
                    Text("Soyad").poppinsFont(size: 16, weight: .semibold)
                    TextField("Soyadınızı girin", text: $viewModel.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .poppinsFont(size: 14)
                }

                // Kullanıcı Adı
                VStack(alignment: .leading, spacing: 4) {
                    Text("Kullanıcı Adı").poppinsFont(size: 16, weight: .semibold)
                    TextField("Kullanıcı adı belirleyin", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .poppinsFont(size: 14)
                }

                // Telefon
                VStack(alignment: .leading, spacing: 4) {
                    Text("Telefon Numarası").poppinsFont(size: 16, weight: .semibold)
                    TextField("05xxxxxxxxx", text: $viewModel.phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                        .poppinsFont(size: 14)
                }

                // Doğum Tarihi
                VStack(alignment: .leading, spacing: 4) {
                    Text("Doğum Tarihi").poppinsFont(size: 16, weight: .semibold)
                    DatePicker("", selection: $viewModel.birthDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                }

                // Kaydet Butonu
                Button(action: {
                    viewModel.updateProfile { success in
                        if success {
                            didCompleteProfile = true
                            showSuccessAlert = true
                        } else {
                            print("Güncelleme başarısız.")
                        }
                    }
                }) {
                    Text("Kaydet")
                        .poppinsFont(size: 16, weight: .semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                // Şifreyi Değiştir Butonu
                NavigationLink(destination: ChangePasswordView(viewModel: viewModel)) {
                    Text("Şifreyi Değiştir")
                        .poppinsFont(size: 16, weight: .semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(10)
                }

            }
            .padding()
        }
        .navigationTitle("Profili Düzenle")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Profiliniz başarıyla güncellendi!", isPresented: $showSuccessAlert) {
            Button("Tamam") {
                dismiss()
            }
            Button("Düzenlemeye Devam Et", role: .cancel) {}
        }
    }
}

