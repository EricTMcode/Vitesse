//
//  AuthResonse.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation

struct AuthResonse: Codable {
    let token: String
    let isAdmin: Bool
}
