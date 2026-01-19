//
//  CandidateDetailView.swift
//  Vitesse
//
//  Created by Eric on 15/01/2026.
//

import SwiftUI

struct CandidateDetailView: View {
//    let candidate: Candidate
    @StateObject var viewModel: CandidateDetailViewModel

    init(candidate: Candidate) {
            _viewModel = StateObject(
                wrappedValue: CandidateDetailViewModel(
                    candidate: candidate
                )
            )
        }

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                        .padding()

                    infoSection
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        viewModel.isEditing.toggle()
                    }
                }
            }
    }
}

private extension CandidateDetailView {
    var header: some View {
        HStack(alignment: .center) {
            Text(viewModel.candidate.fullName.formattedShortName)
                .font(.title)
                .fontWeight(.bold)

            Spacer()

            Image(systemName: viewModel.candidate.isFavorite
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
            LabeledValue(title: "Phone", value: viewModel.candidate.phone)
            LabeledValue(title: "Email", value: viewModel.candidate.email)

            if let linkedinURL = viewModel.candidate.linkedinLink {
                Link(destination: linkedinURL) {
                    Text("GoToLLinkedin")
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Label("Note", systemImage: "note.text")

                if viewModel.isEditing {
                    TextEditor(text: $viewModel.notes)
                        .frame(minHeight: 150)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                } else {
                    Text(viewModel.candidate.note ?? "")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
    }
}

private extension CandidateDetailView {
    func linkedinButton(_ url: URL) -> some View {
            Link(destination: url) {
                Text("goToLinkedIn")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
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

//#Preview {
//    NavigationStack {
//        CandidateDetailView(viewModel: Candidate(id: "1", firstName: "Jean Michel", lastName: "Doe", email: "johndoe@gmail.com", phone: "06 29 61 24 04", linkedinURL: "https", isFavorite: true, note: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived" ))
//    }
//}
