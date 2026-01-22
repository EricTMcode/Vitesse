//
//  MockCandidateService.swift
//  Vitesse
//
//  Created by Eric on 13/01/2026.
//

import Foundation

final class MockCandidateService: CanditatesServiceProtocol {
    var candidatesToReturn: [Candidate] = mockCandidates
    var getCandidatesError: Error?
    var deleteCandidateError: Error?

    private(set) var deletedCandidateIDs: [String] = []

    func getCandidates() async throws -> [Candidate] {
        if let error = getCandidatesError {
            throw error
        }
        return candidatesToReturn
    }


    func deleteCandidate(id: String) async throws {
        if let error = deleteCandidateError {
            throw error
        }

        deletedCandidateIDs.append(id)
    }
}

let mockCandidates: [Candidate] = [
    Candidate(
        id: "1",
        firstName: "Alice",
        lastName: "Martin",
        email: "alice.martin@email.com",
        phone: "0612345678",
        linkedinURL: "https://linkedin.com/in/alicemartin",
        isFavorite: true,
        note: "Strong SwiftUI skills"
    ),
    Candidate(
        id: "2",
        firstName: "Lucas",
        lastName: "Durand",
        email: "lucas.durand@email.com",
        phone: nil,
        linkedinURL: "https://linkedin.com/in/lucasdurand",
        isFavorite: false,
        note: nil
    ),
    Candidate(
        id: "3",
        firstName: "Emma",
        lastName: "Bernard",
        email: "emma.bernard@email.com",
        phone: "0678451234",
        linkedinURL: nil,
        isFavorite: false,
        note: "Junior developer"
    ),
    Candidate(
        id: "4",
        firstName: "Hugo",
        lastName: "Petit",
        email: "hugo.petit@email.com",
        phone: "0601020304",
        linkedinURL: "https://linkedin.com/in/hugopetit",
        isFavorite: true,
        note: "Available immediately"
    ),
    Candidate(
        id: "5",
        firstName: "Chloé",
        lastName: "Rousseau",
        email: "chloe.rousseau@email.com",
        phone: nil,
        linkedinURL: nil,
        isFavorite: false,
        note: nil
    ),
    Candidate(
        id: "6",
        firstName: "Maxime",
        lastName: "Lefevre",
        email: "maxime.lefevre@email.com",
        phone: "0655443322",
        linkedinURL: "https://linkedin.com/in/maximelefevre",
        isFavorite: false,
        note: "Backend-oriented profile"
    ),
    Candidate(
        id: "7",
        firstName: "Sophie",
        lastName: "Moreau",
        email: "sophie.moreau@email.com",
        phone: "0622334455",
        linkedinURL: "https://linkedin.com/in/sophiemoreau",
        isFavorite: true,
        note: "Excellent communication"
    ),
    Candidate(
        id: "8",
        firstName: "Thomas",
        lastName: "De La Roche",
        email: "thomas.garcia@email.com",
        phone: nil,
        linkedinURL: "https://linkedin.com/in/thomasgarcia",
        isFavorite: false,
        note: nil
    ),
    Candidate(
        id: "9",
        firstName: "Laura",
        lastName: "Fournier",
        email: "laura.fournier@email.com",
        phone: "0699887766",
        linkedinURL: nil,
        isFavorite: false,
        note: "Open to remote work"
    ),
    Candidate(
        id: "10",
        firstName: "Antoine",
        lastName: "Blanc",
        email: "antoine.blanc@email.com",
        phone: "0611223344",
        linkedinURL: "https://linkedin.com/in/antoineblanc",
        isFavorite: true,
        note: "Senior iOS developer"
    )
]
