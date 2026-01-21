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
            .navigationBarBackButtonHidden(viewModel.isEditing)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if viewModel.isEditing {
                        Button("Cancel") {
                            viewModel.cancelEditing()
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isEditing {
                        Button("Done") {
                            Task { await viewModel.saveChanges() }
//                            Task { await viewModel.updateFavorite() }
                        }
                    } else {
                        Button("Edit") {
                            viewModel.startEditing()
                        }
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
            if viewModel.isEditing {
                Button {
                    Task { await viewModel.toogleFavorite() }

                } label: {
                    Image(systemName: displayedCandidate.wrappedValue.isFavorite
                          ? SFsymbols.starFill
                          : SFsymbols.star)
                    .foregroundStyle(.yellow)
                    .font(.title2)
                }
            } else {
                Image(systemName: viewModel.candidate.isFavorite
                      ? SFsymbols.starFill
                      : SFsymbols.star)
                .foregroundStyle(.yellow)
                .font(.title2)
            }
        }
    }
}

private extension CandidateDetailView {
    var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("IS FAVORITE \(viewModel.candidate.isFavorite)")
            HStack {
                Text("Phone")
                    .foregroundStyle(.secondary)

                if viewModel.isEditing {
                    TextField("Phone", text: Binding(
                        get: { displayedCandidate.wrappedValue.phone ?? "" },
                        set: { displayedCandidate.wrappedValue.phone = $0 }
                    ))
                    .formTextFieldStyle()
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
                } else {
                    Text(displayedCandidate.wrappedValue.phone ?? "")
                }
            }

            HStack {
                Text("Email")
                    .foregroundStyle(.secondary)

                if viewModel.isEditing {
                    TextField("Email", text: displayedCandidate.email)
                        .formTextFieldStyle()
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    Text(displayedCandidate.wrappedValue.email)
                }
            }









//            LabeledValue(title: "Phone", value: viewModel.candidate.phone, isEditing: viewModel.isEditing)
//            LabeledValue(title: "Email", value: viewModel.candidate.email, isEditing: viewModel.isEditing)

            if viewModel.isEditing {
                TextField("Linkedin", text: Binding(
                    get: { displayedCandidate.wrappedValue.linkedinURL ?? "" },
                    set: { displayedCandidate.wrappedValue.linkedinURL = $0 }
                ))
                .formTextFieldStyle()
                .keyboardType(.URL)
                .textContentType(.URL)
                .textInputAutocapitalization(.never)
            } else {
                if let linkedinURL = viewModel.candidate.linkedinLink {
                    Link(destination: linkedinURL) {
                        Text("GoToLLinkedin")
                    }
                }
            }

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
                        get: { displayedCandidate.wrappedValue.note ?? "" },
                        set: { displayedCandidate.wrappedValue.note = $0 }
                    )
                )
                .formTextFieldStyle()
                .frame(minHeight: 180)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.2))
                )
            } else {
                Text(displayedCandidate.wrappedValue.note ?? "")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
            }
        }
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

private extension CandidateDetailView {
    var displayedCandidate: Binding<Candidate> {
        Binding(
            get: {
                viewModel.draftCandidate ?? viewModel.candidate
            },
            set: { newValue in
                viewModel.draftCandidate = newValue
            }
        )
    }
}

struct LabeledValue: View {
    let title: String
    let value: String?
    let isEditing: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundStyle(.secondary)

            if isEditing {
                TextField(title, text: .constant(value ?? ""))
            } else {
                Text(value ?? "Not availaible")
                    .font(.body)
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        CandidateDetailView(viewModel: Candidate(id: "1", firstName: "Jean Michel", lastName: "Doe", email: "johndoe@gmail.com", phone: "06 29 61 24 04", linkedinURL: "https", isFavorite: true, note: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived" ))
//    }
//}
