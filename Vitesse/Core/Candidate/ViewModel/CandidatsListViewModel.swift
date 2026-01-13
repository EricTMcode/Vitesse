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

    private let candidatsService: CanditatesServiceProtocol

    init(service: CanditatesServiceProtocol = CanditatesService()) {
        self.candidatsService = service
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
}
