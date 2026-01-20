//
//  CandidateUpdateService.swift
//  Vitesse
//
//  Created by Eric on 20/01/2026.
//

import Foundation

protocol CandidateUpdateServiceProtocol {
    func updateCandidate(data: Candidate) async throws
}

class CandidateUpdateService: CandidateUpdateServiceProtocol {
    private let client: HTTPClientProtocol

    init(client: HTTPClientProtocol = HTTPClient()) {
        self.client = client
    }

    func updateCandidate(data: Candidate) async throws {
        try await client.perform(.updateCandidate(data: data))
    }
}

