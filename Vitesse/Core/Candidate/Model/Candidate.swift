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
        let components = fullName.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first }.map { String($0) }
        return initials.joined().uppercased()
    }
}
