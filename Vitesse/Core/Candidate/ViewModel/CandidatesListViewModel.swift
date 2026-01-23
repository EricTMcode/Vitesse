//
//  CandidatsListViewModel.swift
//  Vitesse
//
//  Created by Eric on 13/01/2026.
//

import Foundation

class CandidatesListViewModel: ObservableObject {
    @Published var candidates = [Candidate]()
    @Published var isLoading = false
    @Published var loadingState: ContentLoadingState = .loading
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var showIsFavorite = false
    @Published var showIsEditing = false
    @Published var selectedCandidate = Set<String>()

    private let candidatsService: CanditatesServiceProtocol

    init(service: CanditatesServiceProtocol = CanditatesService()) {
        self.candidatsService = service
    }

    var filteredCandidats: [Candidate] {
        candidates
            .filter { candidat in
                !showIsFavorite || candidat.isFavorite
            }
            .filter { candidat in
                searchText.isEmpty ||
                candidat.firstName.localizedCaseInsensitiveContains(searchText) ||
                candidat.lastName.localizedCaseInsensitiveContains(searchText)
            }
    }

    func getCandidates() async {
        self.errorMessage = nil

        do {
            self.candidates = try await candidatsService.getCandidates()
            self.loadingState = candidates.isEmpty ? .empty : .completed
            print(candidates.count)
        } catch {
            self.loadingState = .error(error: error)
        }
    }

    func refresh() async {
            await getCandidates()
        }

    @MainActor
    func deleteCandidates() async {
        self.errorMessage = nil
        
        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for id in selectedCandidate {
                    group.addTask {
                        try await self.candidatsService.deleteCandidate(id: id)
                    }
                }
                try await group.waitForAll()

                self.loadingState = .completed

                selectedCandidate.removeAll()
                showIsEditing = false
                
                await getCandidates()
            }
        } catch {
            self.loadingState = .error(error: error)
        }
    }
}
