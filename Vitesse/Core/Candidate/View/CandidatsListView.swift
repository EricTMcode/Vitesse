//
//  CandidatsListView.swift
//  Vitesse
//
//  Created by Eric on 11/01/2026.
//

import SwiftUI

struct CandidatsListView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @StateObject var viewModel = CandidatsListViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                candidatesList

                logoutButton
            }
            .environment(\.editMode, .constant(viewModel.showIsEditing ? .active : .inactive))
            .searchable(text: $viewModel.searchText, prompt: Strings.Common.searchCandidate)
            .navigationDestination(for: Candidate.self) { candidat in
                Text("\(candidat.firstName) \(candidat.lastName)")
            }

            .refreshable {
                await viewModel.getCandidates()
            }
            .navigationTitle(Strings.Common.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(viewModel.showIsEditing ? Strings.Common.cancel.capitalized : Strings.Common.edit.capitalized) {
                        viewModel.showIsEditing.toggle()
                        if !viewModel.showIsEditing {
                            viewModel.selectedCandidate.removeAll()
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.showIsEditing {
                        Button {
                            Task { await viewModel.deleteCandidates() }
                        } label: {
                            Text(Strings.Common.delete.capitalized)
                        }
                    } else {
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                viewModel.showIsFavorite.toggle()
                            }
                        } label: {
                            Image(systemName: viewModel.showIsFavorite ? SFsymbols.starFill : SFsymbols.star)
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
            .task {
                await viewModel.getCandidates()
            }
        }
    }
}

private extension CandidatsListView {
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

private extension CandidatsListView {
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
            Text("\(candidate.firstName) \(candidate.lastName)")

            Spacer()

            Image(systemName: candidate.isFavorite ? SFsymbols.starFill : SFsymbols.star)
                .imageScale(.large)
                .foregroundColor(.yellow)
        }
    }
}

#Preview {
    CandidatsListView(loginViewModel: LoginViewModel(), viewModel: CandidatsListViewModel(service: MockCandidateService()))
}
