//
//  CandidateDetailViewModel.swift
//  Vitesse
//
//  Created by Eric on 19/01/2026.
//

import Foundation

class CandidateDetailViewModel: ObservableObject {
    @Published var candidate: Candidate
    @Published var isLoading = false
    @Published var isEditing = false
    @Published var errorMessage : String?

    init(candidate: Candidate) {
        self.candidate = candidate
    }
}
