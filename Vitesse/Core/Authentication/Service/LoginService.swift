//
//  LoginService.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation

protocol LoginServiceProtocol {
    func login(with request: LoginRequest) async throws -> AuthResponse
}

class LoginService: LoginServiceProtocol {
    private let client: HTTPClientProtocol
    
    init(client: HTTPClientProtocol = HTTPClient()) {
        self.client = client
    }
    
    func login(with request: LoginRequest) async throws -> AuthResponse {
        try await client.fetchData(.login(credentials: request))
    }
}
