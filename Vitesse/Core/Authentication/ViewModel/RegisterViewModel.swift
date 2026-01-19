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
    @Published var isRegistrationSuccessful = false

    @Published var errorMessage: ErrorMessage?
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
        isNameValid &&
        isEmailValid &&
        isPasswordValid &&
        isConfirmPasswordValid
    }

    private var isNameValid: Bool {
        !registerRequest.firstName.isEmpty &&
        !registerRequest.lastName.isEmpty
    }

    private var isEmailValid: Bool {
        validationService.validateEmail(registerRequest.email)
    }

    private var isPasswordValid: Bool {
        validationService.validatePassword(registerRequest.password)
    }

    private var isConfirmPasswordValid: Bool {
        validationService.validatePasswordsMatch(
            registerRequest.password,
            registerRequest.confirmPassword
        )
    }

    func register() async {
        guard isFormValid else { return }

        self.isLoading = true
        self.errorMessage = nil

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

    func reset() {
        registerRequest = User()
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        errorMessage = nil
        isRegistrationSuccessful = false
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

