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
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var showIsFavorite = false
    @Published var showIsEditing = false
    @Published var selectedCandidate = Set<String>()

    private let candidatsService: CanditatesServiceProtocol

    init(service: CanditatesServiceProtocol = CanditatesService()) {
        self.candidatsService = service
    }

    //    init(service: CanditatesServiceProtocol = MockCandidateService()) {
    //        self.candidatsService = service
    //    }

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
        self.isLoading = true

        defer { self.isLoading = false }

        do {
            self.candidates = try await candidatsService.getCandidates()
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func deleteCandidates() async {
        self.errorMessage = nil
        self.isLoading = true

        defer { self.isLoading = false }

        do {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for id in selectedCandidate {
                    group.addTask {
                        try await self.candidatsService.deleteCandidate(id: id)
                    }
                }
                try await group.waitForAll()

                selectedCandidate.removeAll()
                showIsEditing = false
                
                self.candidates = try await candidatsService.getCandidates()
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
