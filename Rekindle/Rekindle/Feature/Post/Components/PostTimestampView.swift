//
//  PostTimestampView.swift
//  Rekindle
//
//  Created by Vera Nur on 31.07.2025.
//

import SwiftUI

struct PostTimestampView: View {
    let date: Date?

    var body: some View {
        if let date = date {
            Text(date.formatted(date: .abbreviated, time: .omitted))
                .poppinsFont(size: 11, weight: .regular)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
    }
}
