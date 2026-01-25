//
//  MockLoginService.swift
//  VitesseTests
//
//  Created by Eric on 11/01/2026.
//

import Foundation

final class MockLoginService: LoginServiceProtocol {
    var isAdmin: Bool = false
    
    var lastReceivedRequest: LoginRequest?
    var didLogout = false

    var resultToReturn: Result<Void, Error>?
    var isAuthenticated: Bool = false

    func login(with request: LoginRequest) async throws {
        lastReceivedRequest = request

        switch resultToReturn {
        case .success():
            isAuthenticated = true
            return
        case .failure(let error):
            throw error
        case .none:
            fatalError("Result to return was not set in test setup")
        }
    }

    func logout() {
        self.didLogout = true
        self.isAuthenticated = false
    }
}
