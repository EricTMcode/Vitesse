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

                // DELETE BEFORE SHIP
                logoutButton
            }
            .environment(\.editMode, .constant(viewModel.showIsEditing ? .active : .inactive))
            .navigationDestination(for: Candidate.self) { candidate in
                CandidateDetailView(candidate: candidate)
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
//                    CandidatesCardView(candidate: candidate)
//                        .padding()
                }
            }
        }
//        }
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

extension Candidate {
    var initials: String {
        let components = fullName.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first }.map { String($0) }
        return initials.joined().uppercased()
    }
}
// MARK: - Card View
struct CandidatesCardView: View {
    let candidate: Candidate
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            // Avatar circle with initials
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

            // Name
            VStack(alignment: .leading, spacing: 4) {
                Text(candidate.fullName)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)

                Text("Candidate")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Favorite star
            Image(systemName: candidate.isFavorite ? SFsymbols.starFill : SFsymbols.star)
                .font(.system(size: 24))
                .foregroundColor(candidate.isFavorite ? .yellow : .gray.opacity(0.4))

            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 0.98 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

struct CandidatesRowView: View {
    let candidate: Candidate

    var body: some View {
        HStack {
            // Avatar circle with initials
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

                Text("Candidate")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: candidate.isFavorite ? SFsymbols.starFill : SFsymbols.star)
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
