//
//  LoginService.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation

protocol LoginServiceProtocol {
    func login(with request: LoginRequest) async throws
    func logout()
    var isAuthenticated: Bool { get }
}

class LoginService: LoginServiceProtocol {
    private let client: HTTPClientProtocol
    private let keychain: KeychainHelper


    init(client: HTTPClientProtocol = HTTPClient(), keychain: KeychainHelper = .shared) {
        self.client = client
        self.keychain = keychain
    }

    var isAuthenticated: Bool {
        return keychain.read(account: "authToken") != nil
    }

    func login(with request: LoginRequest) async throws {
        let response: AuthResponse = try await client.fetchData(.login(credentials: request))

        guard let tokenData = response.token.data(using: .utf8) else {
            throw APIError.decodingError("Error decoding token")
        }

        print("DEBUG: TokenData: \(response.token)")

        keychain.save(tokenData, account: "authToken")
        print("DEBUG: Token saved securely.")
    }

    func logout() {
        keychain.delete(account: "authToken")
    }
}
