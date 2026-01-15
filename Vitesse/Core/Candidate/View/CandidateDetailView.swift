//
//  CandidateDetailView.swift
//  Vitesse
//
//  Created by Eric on 15/01/2026.
//

import SwiftUI

struct CandidateDetailView: View {
    let candidate: Candidate

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    infoSection
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {

                    }
                }
            }
        }
    }
}

private extension CandidateDetailView {
    var header: some View {
        HStack(alignment: .center) {
            Text(candidate.fullName)
                .font(.title)
                .fontWeight(.bold)

            Spacer()

            Image(systemName: candidate.isFavorite
                  ? SFsymbols.starFill
                  : SFsymbols.star)
            .foregroundStyle(.yellow)
            .font(.title2)
        }
    }
}

private extension CandidateDetailView {
    var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            LabeledValue(title: "Phone", value: candidate.phone)
            LabeledValue(title: "Email", value: candidate.email)
            LabeledValue(title: "LinkedIn", value: candidate.linkedinURL)
        }
    }
}

struct LabeledValue: View {
    let title: String
    let value: String?

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundStyle(.secondary)

            Text(value ?? "Not availaible")
                .font(.body)
        }
    }
}

#Preview {
    CandidateDetailView(candidate: Candidate(id: "1", firstName: "John", lastName: "Doe", email: "johndoe@gmail.com", phone: "0629612404", linkedinURL: "", isFavorite: true, note: "Welcome Home Bro" ))
}
