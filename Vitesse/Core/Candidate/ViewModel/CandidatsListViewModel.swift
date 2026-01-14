//
//  CandidatsListViewModel.swift
//  Vitesse
//
//  Created by Eric on 13/01/2026.
//

import Foundation

class CandidatsListViewModel: ObservableObject {
    @Published var candidats = [Candidate]()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var showIsFavorite = false
    @Published var showIsEditing = false
    @Published var selectedCandidate = Set<Candidate.ID>()

    private let candidatsService: CanditatesServiceProtocol

    init(service: CanditatesServiceProtocol = CanditatesService()) {
        self.candidatsService = service
    }

//    init(service: CanditatesServiceProtocol = MockCandidateService()) {
//        self.candidatsService = service
//    }

    var filteredCandidats: [Candidate] {
        candidats
                .filter { candidat in
                    !showIsFavorite || candidat.isFavorite
                }
                .filter { candidat in
                    searchText.isEmpty ||
                    candidat.firstName.localizedCaseInsensitiveContains(searchText) ||
                    candidat.lastName.localizedCaseInsensitiveContains(searchText)
                }
    }

    func getCandidats() async {
        self.errorMessage = nil
        self.isLoading = true

        defer { self.isLoading = false }

        do {
            self.candidats = try await candidatsService.getCandidates()
            print("DEBUG: Candidats \(candidats.count)")
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func deleteCandidats() async {
        do {
            try await candidatsService.deleteCandidate(id: selectedCandidate.first!)
            selectedCandidate.removeAll()
            showIsEditing = false
            self.candidats = try await candidatsService.getCandidates()
        } catch {
            print("DEBUG: Deletion failed: \(error)")
        }

        }

//    func deleteSelected() async {
//            do {
//                print(selectedCandidate)
//                try await candidatsService.deleteCandidate(id: selectedCandidate)
//
//                // Optimistic UI update
////                candidats.removeAll { ids.contains($0.id) }
//
//            } catch {
//                print("Deletion failed:", error)
//            }
//        }
}
