//
//  CandidateDetailView.swift
//  Vitesse
//
//  Created by Eric on 15/01/2026.
//

import SwiftUI

struct CandidateDetailView: View {
    @StateObject var viewModel: CandidateDetailViewModel
    @AppStorage("isAdmin") private var isAdmin = false

    init(candidate: Candidate) {
        _viewModel = StateObject(
            wrappedValue: CandidateDetailViewModel(
                candidate: candidate
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                candidateDetails
                infoSection
            }
        }
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .toolbar { CandidateDetailToolbar(viewModel: viewModel) }
    }
}

private extension CandidateDetailView {
    var candidateDetails: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(viewModel.candidate.initials)
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    )
                    .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)

                favoriteView
                    .offset(x: 8, y: -8)
            }

            Text(viewModel.candidate.fullName.formattedShortName)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .padding(.top, 30)
        .padding(.bottom, 24)
    }
}

private extension CandidateDetailView {
    var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "phone.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.green)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Phone")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if viewModel.isEditing {
                        TextField("Phone", text: Binding(
                            get: { viewModel.displayedCandidate.wrappedValue.phone ?? "" },
                            set: { viewModel.displayedCandidate.wrappedValue.phone = $0 }
                        ))
                        .font(.body)
                        .padding(4)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                    } else {
                        Text(viewModel.candidate.phone ?? "")
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            HStack {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.blue)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Email")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    if viewModel.isEditing {
                        TextField("Email", text: viewModel.displayedCandidate.email)
                            .padding(4)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    } else {
                        Text(viewModel.candidate.email)
                            .font(.body)
                            .foregroundStyle(.primary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            HStack {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.blue)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text("LinkedIn")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if viewModel.isEditing {
                        TextField("LinkedIn", text: Binding(
                            get: { viewModel.displayedCandidate.wrappedValue.linkedinURL ?? "" },
                            set: { viewModel.displayedCandidate.wrappedValue.linkedinURL = $0 }
                        ))
                        .padding(4)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .textInputAutocapitalization(.never)
                    } else {
                        if let linkedinURL = viewModel.candidate.linkedinLink {
                            Link(destination: linkedinURL) {
                                Text("Go on LinkedIn")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14))
                    .foregroundStyle(.blue)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)

            noteSection

        }
        .padding(.horizontal)
    }
}

private extension CandidateDetailView {
    var noteSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Note", systemImage: "note.text")

            if viewModel.isEditing {
                TextEditor(
                    text: Binding(
                        get: { viewModel.displayedCandidate.wrappedValue.note ?? "" },
                        set: { viewModel.displayedCandidate.wrappedValue.note = $0 }
                    )
                )
                .formTextFieldStyle()
                .frame(minHeight: 180)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.2))
                )
            } else {
                Text(viewModel.displayedCandidate.wrappedValue.note ?? "")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

private extension CandidateDetailView {
    @ViewBuilder
    private var favoriteView: some View {
        if viewModel.isEditing && isAdmin {
            Button {
                Task { await viewModel.toogleFavorite() }
            } label: {
                favoriteIcon
            }
        } else {
            favoriteIcon
        }
    }
}

private extension CandidateDetailView {
    var favoriteIcon: some View {
        Image(systemName: viewModel.candidate.isFavorite
              ? SFsymbols.starFill
              : SFsymbols.star
        )
        .foregroundStyle(viewModel.candidate.isFavorite ? .yellow : .gray)
        .font(.system(size: 20))
    }
}

struct CandidateDetailToolbar: ToolbarContent {
    @ObservedObject var viewModel: CandidateDetailViewModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if viewModel.isEditing {
                Button {
                    viewModel.cancelEditing()
                } label: {
                    Text("Cancel")
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                }
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            if viewModel.isEditing {
                Button {
                        Task { await viewModel.saveChanges() }
                } label: {
                    Text("Done")
                        .fontWeight(.semibold)
                        .foregroundStyle(viewModel.draftCandidate == viewModel.candidate ? .gray : .blue)
                }
                .disabled(viewModel.draftCandidate == viewModel.candidate)
            } else {
                Button {
                    viewModel.startEditing()
                } label: {
                    Text("Editer")
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        CandidateDetailView(viewModel: Candidate(id: "1", firstName: "Jean Michel", lastName: "Doe", email: "johndoe@gmail.com", phone: "06 29 61 24 04", linkedinURL: "https", isFavorite: true, note: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived" ))
//    }
//}
