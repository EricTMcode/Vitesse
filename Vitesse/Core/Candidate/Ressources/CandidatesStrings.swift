//
//  CandidatesListStrings.swift
//  Vitesse
//
//  Created by Eric on 15/01/2026.
//

import Foundation

enum CandidatesStrings {
    enum Common {
        static let edit = NSLocalizedString("edit", comment: "")
        static let cancel = NSLocalizedString("cancer", comment: "")
        static let delete = NSLocalizedString("delete", comment: "")
        static let saved = NSLocalizedString("save", comment: "")
    }

    enum CandidatesList {
        static let title = NSLocalizedString("Candidats", comment: "")

        static let searchCandidate = NSLocalizedString("Search a candidat", comment: "")
        static let loadingCandidates = NSLocalizedString("Loading of candidats", comment: "")
        static let noCandidatesAvailable = NSLocalizedString("No candidates available", comment: "")
        static let addACandidate = NSLocalizedString("Please add a candidate", comment: "")
        static let reloadView = NSLocalizedString("Reload", comment: "")
        static let candidate = NSLocalizedString("Candidate", comment: "")
    }

    enum CandidateDetail {
        static let isAdmin = "isAdmin"
        static let linkedin = NSLocalizedString("linkedIn", comment: "")
        static let goOnLinkedin = NSLocalizedString("Go on LinkedIn", comment: "")
        static let note = NSLocalizedString("note", comment: "")
        static let noLinkedInAccount = NSLocalizedString("No LinkedIn account", comment: "")
        static let phone = NSLocalizedString("phone", comment: "")
        static let noPhone = NSLocalizedString("Add a number", comment: "")
        static let email = NSLocalizedString("email", comment: "")
    }
}
