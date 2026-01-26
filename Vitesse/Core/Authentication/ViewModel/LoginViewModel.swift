//
//  LoginViewModel.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    private let loginService: LoginServiceProtocol
    private let validationService: ValidationService

    init(service: LoginServiceProtocol = LoginService(), validationService: ValidationService = ValidationService()) {
        self.loginService = service
        self.isAuthenticated = service.isAuthenticated
        self.validationService = validationService
    }

    var formIsValid: Bool {
        validationService.validateEmail(email)
        && !password.isEmpty
        && password.count >= 6
    }

    @MainActor
    func login(email: String, password: String) async {
        self.errorMessage = nil
        self.isLoading = true

        let request = LoginRequest(email: email, password: password)

        defer { self.isLoading = false }

        do {
            try await loginService.login(with: request)
            self.isAuthenticated = loginService.isAuthenticated
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func loginIfPossible() {
        guard formIsValid, !isLoading else { return }
        Task {
            await login(email: email, password: password)
        }
    }

    func logout() {
        loginService.logout()
        self.isAuthenticated = false
    }
}
