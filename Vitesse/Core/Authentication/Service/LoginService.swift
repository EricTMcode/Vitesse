//
//  LoginService.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation
import SwiftUI

protocol LoginServiceProtocol {
    func login(with request: LoginRequest) async throws
    func logout()
    var isAuthenticated: Bool { get }
    var isAdmin: Bool { get }
}

class LoginService: LoginServiceProtocol {
    private let client: HTTPClientProtocol
    private let keychain: KeychainHelper
    private let userDefaults: UserDefaults
    private let isAdminKey = "isAdmin"


    init(client: HTTPClientProtocol = HTTPClient(), keychain: KeychainHelper = .shared, userDefaults: UserDefaults = .standard) {
        self.client = client
        self.keychain = keychain
        self.userDefaults = userDefaults
    }

    var isAuthenticated: Bool {
        keychain.read(account: "authToken") != nil
    }

    var isAdmin: Bool {
        userDefaults.bool(forKey: isAdminKey)
    }

    func login(with request: LoginRequest) async throws {
        let response: AuthResponse = try await client.fetchData(.login(credentials: request))

        guard let tokenData = response.token.data(using: .utf8) else {
            throw APIError.decodingError("Error decoding token")
        }

        print("DEBUG: TokenData: \(response.token)")

        keychain.save(tokenData, account: "authToken")
        userDefaults.set(response.isAdmin, forKey: isAdminKey)
        print("DEBUG: Token saved securely.")
    }

    func logout() {
        keychain.delete(account: "authToken")
        userDefaults.removeObject(forKey: isAdminKey)
    }
}
