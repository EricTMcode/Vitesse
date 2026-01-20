//
//  CandidateDetailViewModel.swift
//  Vitesse
//
//  Created by Eric on 19/01/2026.
//

import Foundation

class CandidateDetailViewModel: ObservableObject {
    @Published var candidate: Candidate
    @Published var draftCandidate: Candidate?

    @Published var isLoading = false
    @Published var isEditing = false
    @Published var errorMessage : String?

    private let candidatesUpdateService: CandidateUpdateServiceProtocol

    init(service: CandidateUpdateServiceProtocol = CandidateUpdateService() ,candidate: Candidate) {
        self.candidatesUpdateService = service
        self.candidate = candidate
    }

    func startEditing() {
        draftCandidate = candidate
        isEditing = true
    }

    func cancelEditing() {
        draftCandidate = nil
        isEditing = false
        errorMessage = nil
    }

    func saveChanges() async {
        guard let draft = draftCandidate else { return }

        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        let body = Candidate(id: candidate.id, firstName: candidate.firstName, lastName: candidate.lastName, email: draft.email, phone: draft.phone, linkedinURL: draft.linkedinURL, isFavorite: candidate.isFavorite, note: draft.note)

        do {
            try await candidatesUpdateService.updateCandidate(data: body)
            self.candidate = body
            print("DEBUG: update saved!")
            self.draftCandidate = nil
            self.isEditing = false

        } catch {
            self.errorMessage = "Impossible de sauvegarder les modifications"
        }
    }
}
