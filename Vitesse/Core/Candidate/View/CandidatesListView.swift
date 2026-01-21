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
                switch viewModel.loadingState {
                case .loading:
                    ProgressView(CandidatesStrings.Common.loadingCandidates)
                case .empty:
                    contentUnavailable
                case .error(let error):
                    Text(error.localizedDescription)
                case .completed:
                    SearchBarView(searchText: $viewModel.searchText)
                    candidatesList
                }

                Text("USER IS \(loginViewModel.isAdmin)")
                // DELETE BEFORE SHIP
                logoutButton
            }
            .environment(\.editMode, .constant(viewModel.showIsEditing ? .active : .inactive))
            .navigationDestination(for: Candidate.self) { candidate in
                CandidateDetailView(candidate: candidate, isAdmin: loginViewModel.isAdmin)
            }
            .refreshable { await viewModel.refresh() }
            .navigationTitle(CandidatesStrings.Common.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { CandidatesToolbar(viewModel: viewModel) }
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
        .padding(.horizontal, 5)
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

private extension CandidatesListView {
    var contentUnavailable: some View {
        ContentUnavailableView {
            Label(CandidatesStrings.Common.noCandidatesAvailable, systemImage: SFsymbols.personSlash)
        } description: {
            Text(CandidatesStrings.Common.addACandidate)
        } actions: {
            Button() {
                Task { await viewModel.refresh() }
            } label: {
                Text(CandidatesStrings.Common.reloadView)
                    .primaryButtonStyle()
                    .overlay {
                        if viewModel.loadingState == .loading {
                            ProgressView()
                        }
                    }
            }
        }
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
        ? CandidatesStrings.Common.cancel.capitalized
        : CandidatesStrings.Common.edit.capitalized
    }

    @ViewBuilder
    private var trailingButton: some View {
        if viewModel.showIsEditing {
            Button(CandidatesStrings.Common.delete.capitalized) {
                Task { await viewModel.deleteCandidates() }
            }
            .disabled(viewModel.selectedCandidate.isEmpty)
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
