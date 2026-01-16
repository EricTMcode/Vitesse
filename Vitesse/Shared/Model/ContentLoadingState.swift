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
}