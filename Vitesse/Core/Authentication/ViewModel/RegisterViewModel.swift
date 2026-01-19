//
//  RegisterViewModel.swift
//  Vitesse
//
//  Created by Eric on 12/01/2026.
//

import Foundation

class RegisterViewModel: ObservableObject {
    @Published var registerRequest = User()
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    @Published var isRegistrationSuccessful = false

    private let registerService: RegisterServiceProtocol
    private let validationService: ValidationService

    init(service: RegisterServiceProtocol = RegisterService(), validationService: ValidationService = ValidationService()) {
        self.registerService = service
        self.validationService = validationService
    }

    var isFormValid: Bool {
        !registerRequest.firstName.isEmpty &&
        !registerRequest.lastName.isEmpty &&
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
            self.isRegistrationSuccessful = true
            print("DEBUG: REGISTRATION Successfull!")
        } catch {
            print("DEBUG: ERROR: \(error.localizedDescription)")
            self.errorMessage = ErrorMessage(text: error.localizedDescription)
        }
    }

    func validateEmail() {
        guard !registerRequest.email.isEmpty else {
            emailError = nil
            return
        }

        emailError = validationService.validateEmail(registerRequest.email)
        ? nil
        : RegistrationError.invalidEmail.rawValue
    }

    func validatePassword() {
        guard !registerRequest.password.isEmpty else {
            passwordError = nil
            return
        }

        passwordError = validationService.validatePassword(registerRequest.password)
        ? nil
        : RegistrationError.weakPassword.rawValue
    }

    func validateConfirmPassword() {
        guard !registerRequest.confirmPassword.isEmpty else {
            confirmPasswordError = nil
            return
        }

        confirmPasswordError = validationService.validatePasswordsMatch(registerRequest.password, registerRequest.confirmPassword)
        ? nil
        : RegistrationError.passwordMisMatch.rawValue
    }
}

