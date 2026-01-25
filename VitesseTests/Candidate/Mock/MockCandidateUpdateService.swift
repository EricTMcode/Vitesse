//
//  MockCandidateUpdateService.swift
//  VitesseTests
//
//  Created by Eric on 23/01/2026.
//

import Foundation

final class MockCandidateUpdateService: CandidateUpdateServiceProtocol {
    private(set) var updateCandidateCalled = false
    private(set) var toggleFavoriteCalled = false

    private(set) var updatedCandidate: Candidate?
    private(set) var toggledFavoriteId: String?

    var updateCandidateError: Error?
    var toggleFavoriteError: Error?

    func updateCandidate(data: Candidate) async throws {
        updateCandidateCalled = true
        updatedCandidate = data

        if let error = updateCandidateError {
            throw error
        }
    }

    func toggleFavorite(id: String) async throws {
        toggleFavoriteCalled = true
        toggledFavoriteId = id

        if let error = toggleFavoriteError {
            throw error
        }
    }
}
