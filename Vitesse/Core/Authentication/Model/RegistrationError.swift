//
//  RegistrationError.swift
//  Vitesse
//
//  Created by Eric on 19/01/2026.
//

import Foundation

enum RegistrationError: String {
    case invalidEmail = "Please enter a valid email address"
    case weakPassword = "Password must contain uppercase, lowercase, number, and special character"
    case passwordMisMatch = "Passwords do not match"
}
