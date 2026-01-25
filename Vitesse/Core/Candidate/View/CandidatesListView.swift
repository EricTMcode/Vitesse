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
                    ProgressView(CandidatesStrings.CandidatesList.loadingCandidates)
                case .empty:
                    contentUnavailable
                case .error(let error):
                    Text(error.localizedDescription)
                case .completed:
                    SearchBarView(searchText: $viewModel.searchText)
                    candidatesList
                }

                // DELETE BEFORE SHIP
                logoutButton
            }
            .environment(\.editMode, .constant(viewModel.showIsEditing ? .active : .inactive))
            .navigationDestination(for: Candidate.self) { candidate in
                CandidateDetailView(candidate: candidate)
            }
            .refreshable { await viewModel.refresh() }
            .navigationTitle(CandidatesStrings.CandidatesList.title)
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
                    CandidatesCardView(candidate: candidate)
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
            Label(CandidatesStrings.CandidatesList.noCandidatesAvailable, systemImage: SFSymbols.personSlash)
        } description: {
            Text(CandidatesStrings.CandidatesList.addACandidate)
        } actions: {
            Button() {
                Task { await viewModel.refresh() }
            } label: {
                Text(CandidatesStrings.CandidatesList.reloadView)
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

struct CandidatesCardView: View {
    let candidate: Candidate

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)

                Text(candidate.initials)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(candidate.fullName)
                    .fontWeight(.semibold)

                Text(CandidatesStrings.CandidatesList.candidate)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: candidate.isFavorite ? SFSymbols.starFill : SFSymbols.star)
                .imageScale(.large)
                .foregroundColor(candidate.isFavorite ? .yellow : .gray.opacity(0.4))
        }
    }
}

struct CandidatesToolbar: ToolbarContent {
    @ObservedObject var viewModel: CandidatesListViewModel

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                toggleEditMode()
            } label: {
                Text(editButtonTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(viewModel.showIsEditing ? .red : .blue)
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
            Button {
                Task { await viewModel.deleteCandidates() }
            } label: {
                Text(CandidatesStrings.Common.delete.capitalized)
                    .fontWeight(.bold)
                    .foregroundStyle(viewModel.selectedCandidate.isEmpty ? .gray : .red)
            }
            .disabled(viewModel.selectedCandidate.isEmpty)
        } else {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.showIsFavorite.toggle()
                }
            } label: {
                Image(systemName: viewModel.showIsFavorite
                      ? SFSymbols.starFill
                      : SFSymbols.star)
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
