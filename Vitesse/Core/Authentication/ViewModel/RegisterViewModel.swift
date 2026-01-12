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
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let registerService: RegisterServiceProtocol

    init(service: RegisterServiceProtocol = RegisterService()) {
        self.registerService = service
    }

    func register() async {
        self.errorMessage = nil
        self.isLoading = true

        defer { isLoading = false }

        let request = Register(firstName: firstname, lastName: lastname, email: email, password: password, confirmPassword: password)

        do {
            try await registerService.register(with: request)
            print("DEBUG: REGISTRATION Successfull!")
        } catch {
            print("DEBUG: ERROR: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
}
