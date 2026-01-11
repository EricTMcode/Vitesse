//
//  AuthResponse.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation

struct AuthResponse: Codable {
    let token: String
    let isAdmin: Bool
}
