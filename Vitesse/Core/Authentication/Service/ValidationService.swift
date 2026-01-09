//
//  ValidationService.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation

class ValidationService {
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func validatePassword(_ password: String) -> Bool {
        // At least 8 characters
        guard password.count >= 8 else { return false }

        // Contains uppercase letter
        let uppercaseRegex = ".*[A-Z]+.*"
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
        guard uppercasePredicate.evaluate(with: password) else { return false }

        // Contains lowercase letter
        let lowercaseRegex = ".*[a-z]+.*"
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseRegex)
        guard lowercasePredicate.evaluate(with: password) else { return false }

        // Contains number
        let numberRegex = ".*[0-9]+.*"
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        guard numberPredicate.evaluate(with: password) else { return false }

        // Contains special character
        let specialCharRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]+.*"
        let specialCharPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharRegex)
        guard specialCharPredicate.evaluate(with: password) else { return false }

        return true
    }

    func validatePasswordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        return !password.isEmpty && password == confirmPassword
    }
}
