//
//  AuthenticationStrings.swift
//  Vitesse
//
//  Created by Eric on 16/01/2026.
//

import Foundation

enum AuthenticationStrings {
    enum LoginView {
        static let accessibilityLabelLogo = NSLocalizedString("Vitesse Logo", comment: "")
        static let emailField = NSLocalizedString("Enter your email", comment: "")
        static let passwordField = NSLocalizedString("Password", comment: "")
        static let forgotPassword = NSLocalizedString("Forget password?", comment: "")
        static let connexionButton = NSLocalizedString("Sign in", comment: "")
        static let createAccount = NSLocalizedString("Register", comment: "")
        static let noAccount = NSLocalizedString("No account?", comment: "")
        static let signUp = NSLocalizedString("Register", comment: "")
    }

    enum RegisterView {
        static let success = NSLocalizedString("success", comment: "")
        static let ok = NSLocalizedString("ok", comment: "")
        static let error = NSLocalizedString("error", comment: "")
        static let accountCreatedSuccessfully = NSLocalizedString("Your account has been successfully created", comment: "")
    }
}
