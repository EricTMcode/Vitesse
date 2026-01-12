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

    private let registerService: RegisterServiceProtocol
    private let validationService: ValidationService

    init(service: RegisterServiceProtocol = RegisterService(), validationService: ValidationService = ValidationService()) {
        self.registerService = service
        self.validationService = validationService
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

    
}
