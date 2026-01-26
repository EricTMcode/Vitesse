//
//  CanditatesService.swift
//  Vitesse
//
//  Created by Eric on 13/01/2026.
//

import Foundation

protocol CanditatesServiceProtocol {
    func getCandidates() async throws -> [Candidate]
    func deleteCandidate(id: String) async throws
}

class CanditatesService: CanditatesServiceProtocol {
    private let client: HTTPClientProtocol
    
    init(client: HTTPClientProtocol = HTTPClient()) {
        self.client = client
    }
    
    func getCandidates() async throws -> [Candidate] {
        try await client.fetchData(.candidates)
    }
    
    func deleteCandidate(id: String) async throws {
        try await client.perform(.deleteCandidate(id: id))
    }
}
