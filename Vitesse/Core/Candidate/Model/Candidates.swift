//
//  Candidates.swift
//  Vitesse
//
//  Created by Eric on 13/01/2026.
//

import Foundation

struct Candidates: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastNAme: String
    let email: String
    let phone: String?
    let linkedinURL: String?
    let isFavorite: Bool
    let note: String?
}
