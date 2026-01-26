//
//  CandidateDetailViewModel.swift
//  Vitesse
//
//  Created by Eric on 19/01/2026.
//

import SwiftUI

final class CandidateDetailViewModel: ObservableObject {
    @Published var candidate: Candidate
    @Published var draftCandidate: Candidate?
    @Published var isLoading = false
    @Published var isEditing = false
    @Published var errorMessage : String?

    var isAdmin: Bool

    private let candidatesUpdateService: CandidateUpdateServiceProtocol

    init(service: CandidateUpdateServiceProtocol = CandidateUpdateService() ,candidate: Candidate, isAdmin: Bool) {
        self.candidatesUpdateService = service
        self.candidate = candidate
        self.isAdmin = isAdmin

    }

    var displayedCandidate: Binding<Candidate> {
        Binding(
            get: {
                self.draftCandidate ?? self.candidate
            },
            set: { newValue in
                self.draftCandidate = newValue
            }
        )
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

    @MainActor
    func saveChanges() async {
        guard let draft = draftCandidate else { return }

        self.isLoading = true
        self.errorMessage = nil

        defer { isLoading = false }

        let body = Candidate(id: candidate.id, firstName: candidate.firstName, lastName: candidate.lastName, email: draft.email, phone: draft.phone, linkedinURL: draft.linkedinURL, isFavorite: candidate.isFavorite, note: draft.note)

        do {
            try await candidatesUpdateService.updateCandidate(data: body)
            self.candidate = body
            self.draftCandidate = nil
            self.isEditing = false
        } catch {
            self.errorMessage = "Impossible de sauvegarder les modifications"
        }
    }

    @MainActor
    func toggleFavorite() async {
        guard isAdmin else {
            self.errorMessage = "Vous n’avez pas les droits administrateur"
            return
        }

        self.isLoading = true
        self.errorMessage = nil

        defer { isLoading = false }

        do {
            try await candidatesUpdateService.toggleFavorite(id: candidate.id)
            self.candidate.isFavorite.toggle()
        } catch {
            self.errorMessage = "Vous n’avez pas les droits administrateur"
        }
    }
}
