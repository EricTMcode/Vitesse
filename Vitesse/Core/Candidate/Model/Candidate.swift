//
//  Candidate.swift
//  Vitesse
//
//  Created by Eric on 13/01/2026.
//

import Foundation

struct Candidate: Identifiable, Codable, Hashable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?
    let linkedinURL: String?
    let isFavorite: Bool
    let note: String?

    var fullName: String {
       return "\(firstName) \(lastName)"
    }

    var linkedinLink: URL? {
        guard let linkedinURL, let url = URL(string: linkedinURL) else {
            return nil
        }
        return url
    }
}
