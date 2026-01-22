//
//  ContentLoadingState.swift
//  Vitesse
//
//  Created by Eric on 15/01/2026.
//


enum ContentLoadingState {
    case loading
    case empty
    case error(error: Error)
    case completed
    case refresh
}

extension ContentLoadingState: Equatable {
    static func == (lhs: ContentLoadingState, rhs: ContentLoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.empty, .empty), (.completed, .completed):
            return true
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
