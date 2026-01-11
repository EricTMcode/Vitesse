//
//  MockLoginService.swift
//  VitesseTests
//
//  Created by Eric on 11/01/2026.
//

import Foundation

class MockLoginService: LoginServiceProtocol {
    var resultToReturn: Result<AuthResponse, Error>?
    var lastReceivedRequest: LoginRequest?

    func login(with request: LoginRequest) async throws -> AuthResponse {
        lastReceivedRequest = request

        switch resultToReturn {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        case nil:
            fatalError("Result to return was not set in test setup")
        }
    }
}
