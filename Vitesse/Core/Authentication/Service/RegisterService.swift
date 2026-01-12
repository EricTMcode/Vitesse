//
//  RegisterService.swift
//  Vitesse
//
//  Created by Eric on 12/01/2026.
//

import Foundation

protocol RegisterServiceProtocol {
    func register(with request: User) async throws
}

class RegisterService: RegisterServiceProtocol {
    private let client: HTTPClientProtocol

    init(client: HTTPClientProtocol = HTTPClient()) {
        self.client = client
    }

    func register(with request: User) async throws {
        try await client.perform(.register(user: request))
    }
}
