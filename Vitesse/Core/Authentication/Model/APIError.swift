//
//  APIError.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation

enum APIError: Error {
    case invalidCredentials
    case invalidURL
    case invalidResponse
    case decodingError(String)
    case serverError(String)
    case networkError
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)

    var errorDescription: String {
        switch self {
        case .invalidCredentials:
            return "Email or password incorrect"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid reponse from the server"
        case .decodingError(let message):
            return "Invalid server response : \(message)"
        case .serverError(let message):
            return message
        case .networkError:
            return "No internet connection"
        case .invalidStatusCode(let statusCode):
            return "Invalid status code: \(statusCode)"
        case .unknownError(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
