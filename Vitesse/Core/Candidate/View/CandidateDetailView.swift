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
                candidate: candidate,
                isAdmin: UserDefaults.standard.bool(forKey: "isAdmin")
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
                .font(.title)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .padding(.top, 30)
        .padding(.bottom, 24)
    }
}

private extension CandidateDetailView {
    var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            InfosRow(
                icon: "phone.fill",
                iconColor: .green,
                label: "Phone",
                isEditing: viewModel.isEditing,
                editableValue: Binding(
                    get: { viewModel.displayedCandidate.wrappedValue.phone ?? "" },
                    set: { viewModel.displayedCandidate.wrappedValue.phone = $0 }
                ),
                displayValue: viewModel.candidate.phone ?? "Ajoutez un numéro",
                placeholder: "Phone",
                keyboardType: .phonePad,
                textContentType: .telephoneNumber,
                autocapitalization: .never,
                autocorrection: false)

            InfosRow(
                icon: "envelope.fill",
                iconColor: .blue,
                label: "Email",
                isEditing: viewModel.isEditing,
                editableValue: viewModel.displayedCandidate.email,
                displayValue: viewModel.candidate.email,
                placeholder: "Email",
                keyboardType: .emailAddress,
                textContentType: .emailAddress,
                autocapitalization: .never,
                autocorrection: false)

            LinkedInRow(
                isEditing: viewModel.isEditing,
                editableValue: Binding(
                    get: { viewModel.displayedCandidate.wrappedValue.linkedinURL ?? "Pas de compte LinkedIn" },
                    set: { viewModel.displayedCandidate.wrappedValue.linkedinURL = $0 }
                ),
                linkedinURL: viewModel.candidate.linkedinLink)

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
                Task { await viewModel.toggleFavorite() }
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

struct InfosRow: View {
    let icon: String
    let iconColor: Color
    let label: String
    let isEditing: Bool
    let editableValue: Binding<String>
    let displayValue: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    var textContentType: UITextContentType? = nil
    var autocapitalization: TextInputAutocapitalization = .sentences
    var autocorrection: Bool = true

    var body: some View {
        RowContainer {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(iconColor)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if isEditing {
                    TextField(placeholder, text: editableValue)
                        .editTextFieldStyle()
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                        .textInputAutocapitalization(autocapitalization)
                        .autocorrectionDisabled(!autocorrection)
                } else {
                    Text(displayValue)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.caption)
        }
    }
}

struct LinkedInRow: View {
    let isEditing: Bool
    let editableValue: Binding<String>
    let linkedinURL: URL?

    var body: some View {
        RowContainer {
            Image(systemName: "link.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(.blue)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text("LinkedIn")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if isEditing {
                    TextField("LinkedIn", text: editableValue)
                        .editTextFieldStyle()
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .textInputAutocapitalization(.never)
                } else {
                    if let linkedinURL {
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
                .foregroundStyle(linkedinURL == nil ? Color(.secondaryLabel) : .blue)
        }
    }
}

struct RowContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack {
            content
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        CandidateDetailView(candidate: mockCandidates[1])
    }
}
