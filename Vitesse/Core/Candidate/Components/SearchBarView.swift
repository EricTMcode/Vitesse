//
//  SearchBarView.swift
//  Vitesse
//
//  Created by Eric on 19/01/2026.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField(CandidatesStrings.Common.searchCandidate, text: $searchText)
                .foregroundStyle(.secondary)
                .autocorrectionDisabled()
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(.secondary)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    , alignment: .trailing
                )
        }
        .font(.subheadline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.15), radius: 3, x: 3, y: 3)
        )
        .padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
