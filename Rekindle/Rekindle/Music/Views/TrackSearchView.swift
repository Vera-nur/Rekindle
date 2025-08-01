//
//  TrackSearchView.swift
//  Rekindle
//
//  Created by Vera Nur on 1.08.2025.
//

import SwiftUI
import Kingfisher

struct TrackSearchView: View {
    @Binding var selectedTrack: Audius.Track?
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = TrackSearchViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Arama Çubuğu
                HStack {
                    TextField("Şarkı veya sanatçı ara", text: $vm.query)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit {
                            Task { await vm.search() }
                        }
                    Button("Ara") {
                        Task { await vm.search() }
                    }
                }
                .padding()

                // Yükleniyor Göstergesi
                if vm.isLoading {
                    ProgressView()
                        .padding()
                }

                // Sonuç Listesi
                List(vm.results) { track in
                    HStack {
                        if let url = track.artwork?.small {
                            KFImage(url)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                        VStack(alignment: .leading) {
                            Text(track.title)
                                .lineLimit(1)
                            Text(track.user.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if selectedTrack?.id == track.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTrack = track
                        dismiss()
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Şarkı Seç")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Kapat") { dismiss() }
                }
            }
        }
    }
}
