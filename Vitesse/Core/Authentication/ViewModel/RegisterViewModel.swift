//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Eric on 12/01/2026.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var firstname = ""
    @Published var lastname = ""
    @Published var email = ""
    @Published var password = ""
    @Published var registerRequest = User()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?

    private let registerService: RegisterServiceProtocol
    private let validationService: ValidationService

    init(service: RegisterServiceProtocol = RegisterService(), validationService: ValidationService = ValidationService()) {
        self.registerService = service
        self.validationService = validationService
    }

    var isFormValid: Bool {
        !registerRequest.firstName.isEmpty &&
        !registerRequest.lastName.isEmpty &&
        emailError == nil &&
        passwordError == nil &&
        confirmPasswordError == nil &&
        validationService.validateEmail(registerRequest.email) &&
        validationService.validatePassword(registerRequest.password) &&
        validationService.validatePasswordsMatch(registerRequest.password, registerRequest.confirmPassword)
    }


    func register() async {
        self.errorMessage = nil
        self.isLoading = true

        defer { isLoading = false }

        do {
            try await registerService.register(with: registerRequest)
            print("DEBUG: REGISTRATION Successfull!")
        } catch {
            print("DEBUG: ERROR: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }

    func validateEmail() {
        if registerRequest.email.isEmpty {
            emailError = nil
        } else if !validationService.validateEmail(registerRequest.email) {
            emailError = "Please enter a valid email address"
        } else {
            emailError = nil
        }
    }
}
