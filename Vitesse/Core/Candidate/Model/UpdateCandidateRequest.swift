//
//  UpdateCandidateRequest.swift
//  Vitesse
//
//  Created by Eric on 20/01/2026.
//

import Foundation

struct UpdateCandidateRequest: Codable {
    let email: String
    let phone: String
    let linkedinURL: String?
    let note: String
}
