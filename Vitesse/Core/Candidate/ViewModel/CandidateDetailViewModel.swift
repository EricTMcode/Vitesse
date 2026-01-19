//
//  CandidateDetailViewModel.swift
//  Vitesse
//
//  Created by Eric on 19/01/2026.
//

import Foundation

class CandidateDetailViewModel: ObservableObject {
    @Published var candidate: Candidate
    @Published var isEditing: Bool = false

    @Published var notes = ""

    init(candidate: Candidate) {
        self.candidate = candidate
    }
}
