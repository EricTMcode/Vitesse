//
//  CandidatesListView.swift
//  Vitesse
//
//  Created by Eric on 11/01/2026.
//

import SwiftUI

struct CandidatesListView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @StateObject var viewModel = CandidatesListViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                candidatesList

                // DELETE BEFORE SHIP
//                logoutButton
            }
            .environment(\.editMode, .constant(viewModel.showIsEditing ? .active : .inactive))
            .searchable(text: $viewModel.searchText, prompt: CandidatesListStrings.Common.searchCandidate)
            .navigationDestination(for: Candidate.self) { candidate in
                CandidateDetailView(candidate: candidate)
            }
            .refreshable { await viewModel.refresh() }
            .navigationTitle(CandidatesListStrings.Common.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { CandidatesToolbar(viewModel: viewModel) }
            .overlay {
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .task { await viewModel.getCandidates() }
        }
    }
}

private extension CandidatesListView {
    var candidatesList: some View {
        List(selection: $viewModel.selectedCandidate) {
            ForEach(viewModel.filteredCandidats) { candidate in
                NavigationLink(value: candidate) {
                    CandidatesRowView(candidate: candidate)
                }
            }
        }
        .listStyle(.plain)
    }
}

private extension CandidatesListView {
    var logoutButton: some View {
        Button("Logout") {
            loginViewModel.logout()
        }
        .buttonStyle(.bordered)
    }
}

struct CandidatesRowView: View {
    let candidate: Candidate

    var body: some View {
        HStack {
            Text(candidate.fullName)

            Spacer()

            Image(systemName: candidate.isFavorite ? SFsymbols.starFill : SFsymbols.star)
                .imageScale(.large)
                .foregroundColor(.yellow)
        }
    }
}

struct CandidatesToolbar: ToolbarContent {
    @ObservedObject var viewModel: CandidatesListViewModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(editButtonTitle) {
                toggleEditMode()
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            trailingButton
        }
    }

    private var editButtonTitle: String {
        viewModel.showIsEditing
        ? CandidatesListStrings.Common.cancel.capitalized
        : CandidatesListStrings.Common.edit.capitalized
    }

    @ViewBuilder
    private var trailingButton: some View {
        if viewModel.showIsEditing {
            Button(CandidatesListStrings.Common.delete.capitalized) {
                Task { await viewModel.deleteCandidates() }
            }
        } else {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.showIsFavorite.toggle()
                }
            } label: {
                Image(systemName: viewModel.showIsFavorite
                      ? SFsymbols.starFill
                      : SFsymbols.star)
                .foregroundStyle(.yellow)
            }
        }
    }

    private func toggleEditMode() {
        viewModel.showIsEditing.toggle()
        if !viewModel.showIsEditing {
            viewModel.selectedCandidate.removeAll()
        }
    }
}

#Preview {
    CandidatesListView(loginViewModel: LoginViewModel(), viewModel: CandidatesListViewModel(service: MockCandidateService()))
}
