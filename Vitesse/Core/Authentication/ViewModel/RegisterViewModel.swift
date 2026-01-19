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
        if registerRequest.email.isEmpty {
            emailError = nil
        } else if !validationService.validateEmail(registerRequest.email) {
            emailError = "Please enter a valid email address"
        } else {
            emailError = nil
        }
    }

    func validatePassword() {
        if registerRequest.password.isEmpty {
            passwordError = nil
        } else if !validationService.validatePassword(registerRequest.password) {
            passwordError = "Password must contain uppercase, lowercase, number, and special character"
        } else {
            passwordError = nil
        }
    }

    func validateConfirmPassword() {
        if registerRequest.confirmPassword.isEmpty {
            confirmPasswordError = nil
        } else if !validationService.validatePasswordsMatch(registerRequest.password, registerRequest.confirmPassword) {
            confirmPasswordError = "Passwords do not match"
        } else {
            confirmPasswordError = nil
        }
    }
}

enum ValidationError: String {
    case invalidEmail = "Please enter a valid email address"
    case weakPassword = "Password must contain uppercase, lowercase, number, and special character"
    case passwordMisMatch = "Passwords do not match"
}
