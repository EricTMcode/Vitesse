//
//  CandidatesListStrings.swift
//  Vitesse
//
//  Created by Eric on 15/01/2026.
//

import Foundation

enum CandidatesStrings {
    enum Common {
        static let edit = NSLocalizedString("editer", comment: "")
        static let cancel = NSLocalizedString("annuler", comment: "")
        static let delete = NSLocalizedString("effacer", comment: "")
        static let saved = NSLocalizedString("enregistrer", comment: "")
    }

    enum CandidatesList {
        static let title = NSLocalizedString("Candidats", comment: "")

        static let searchCandidate = NSLocalizedString("Rechercher un candidat", comment: "")
        static let loadingCandidates = NSLocalizedString("Chargement des candidats", comment: "")
        static let noCandidatesAvailable = NSLocalizedString("Aucun Candidats", comment: "")
        static let addACandidate = NSLocalizedString("Merci d'ajouter un candidat", comment: "")
        static let reloadView = NSLocalizedString("Recharger", comment: "")
        static let candidate = NSLocalizedString("Candidate", comment: "")
    }

    enum CandidateDetail {
        
    }
}
