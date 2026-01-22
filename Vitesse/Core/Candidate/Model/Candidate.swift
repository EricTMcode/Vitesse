//
//  Candidate.swift
//  Vitesse
//
//  Created by Eric on 13/01/2026.
//

import Foundation

struct Candidate: Identifiable, Codable, Hashable {
    let id: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String?
    var linkedinURL: String?
    var isFavorite: Bool
    var note: String?

    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    var linkedinLink: URL? {
        guard let linkedinURL, let url = URL(string: linkedinURL) else {
            return nil
        }
        return url
    }

    var initials: String {
        let particles: Set<String> = ["de", "la", "du", "des", "van", "von", "da", "di", "del"]

        let components = fullName
            .lowercased()
            .split(separator: " ")
            .filter { !particles.contains(String($0)) }

        guard let first = components.first?.first,
              let last = components.last?.first else {
            return ""
        }

        return "\(first)\(last)".uppercased()
    }
}
