//
//  CanditatesService.swift
//  Vitesse
//
//  Created by Eric on 13/01/2026.
//

import Foundation

protocol CanditatesServiceProtocol {
    func getCandidates() async throws -> [Candidate]
}

class CanditatesService: CanditatesServiceProtocol {
    private let client: HTTPClientProtocol

    init(client: HTTPClientProtocol = HTTPClient()) {
        self.client = client
    }

    func getCandidates() async throws -> [Candidate] {
       try await client.fetchData(.candidates)
    }
}
