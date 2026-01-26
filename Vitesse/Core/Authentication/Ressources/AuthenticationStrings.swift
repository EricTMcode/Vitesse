//
//  AuthenticationStrings.swift
//  Vitesse
//
//  Created by Eric on 16/01/2026.
//

import Foundation

enum AuthenticationStrings {

    enum Common {
        static let accessibilityLabelLogo = NSLocalizedString("Vitesse Logo", comment: "")
    }

    enum LoginView {
        static let emailField = NSLocalizedString("Enter your email", comment: "")
        static let passwordField = NSLocalizedString("Password", comment: "")
        static let forgotPassword = NSLocalizedString("Forget password?", comment: "")
        static let connexionButton = NSLocalizedString("Sign in", comment: "")
        static let createAccount = NSLocalizedString("Register", comment: "")
        static let noAccount = NSLocalizedString("Don't have an account?", comment: "")
        static let signUp = NSLocalizedString("Sign Up", comment: "")
        static let or = NSLocalizedString("or", comment: "")
    }

    enum RegisterView {
        static let success = NSLocalizedString("success", comment: "")
        static let ok = NSLocalizedString("ok", comment: "")
        static let error = NSLocalizedString("error", comment: "")
        static let accountCreatedSuccessfully = NSLocalizedString("Your account has been successfully created", comment: "")
        static let registerTitle = NSLocalizedString("register", comment: "")
        static let firstName = NSLocalizedString("First Name", comment: "")
        static let firstNameField = NSLocalizedString("Enter your first name", comment: "")
        static let lastName = NSLocalizedString("Last Name", comment: "")
        static let lastNameField = NSLocalizedString("Enter your last name", comment: "")
        static let email = NSLocalizedString("email", comment: "")
        static let emailField = NSLocalizedString("Enter your email", comment: "")
        static let password = NSLocalizedString("password", comment: "")
        static let passwordField = NSLocalizedString("Enter your password", comment: "")
        static let confirmPassword = NSLocalizedString("Confirm password", comment: "")
        static let confirmPasswordField = NSLocalizedString("Confirm your password", comment: "")
        static let mustInclude = NSLocalizedString("Must include uppercase, lowercase, number, and special character", comment: "")
        static let createYourAccount = NSLocalizedString("Create your account", comment: "")
        static let getAccount = NSLocalizedString("Already have an account?", comment: "")
        static let signIn = NSLocalizedString("Sign In", comment: "")

    }
}
