//
//  LoginViewModel.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var userToken: String?
    @Published var isAuthenticated = false
    
    private let loginService: LoginServiceProtocol
    private let validationService: ValidationService
    
    init(service: LoginServiceProtocol = LoginService(), validationService: ValidationService = ValidationService()) {
        self.loginService = service
        self.validationService = validationService
    }
    
    var formIsValid: Bool {
        validationService.validateEmail(email) &&
        !password.isEmpty &&
        password.count >= 6
    }
    
    func login() async {
        self.errorMessage = nil
        self.isLoading = true
        
        let request = LoginRequest(email: email, password: password)
        
        defer { isLoading = false }
        
        do {
            let response = try await loginService.login(with: request)
            self.userToken = response.token
            self.isAuthenticated = true
            print("Login Successfull! Is Admin: \(response.isAdmin)")
            print("Token: \(response.token)")
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func logout() {
        userToken = nil
        isAuthenticated = false
        print("Logout Successfull!")
        print("Token: \(userToken)")
    }
}
