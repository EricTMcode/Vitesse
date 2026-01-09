//
//  HTTPClient.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation

protocol HTTPClientProtocol {
    func fetchData<T: Codable>(_ endpoint: APIEndpoint) async throws -> T
    func perform(_ endpoint: APIEndpoint) async throws
}

class HTTPClient: HTTPClientProtocol {
    func fetchData<T: Codable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.request else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(for: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }

        try httpResponse.validate(data: data)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError("Decoding error: \(error)")
        }
    }
    
    func perform(_ endpoint: APIEndpoint) async throws {
        guard let url = endpoint.request else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(for: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        try httpResponse.validate(data: data)
    }
}

extension HTTPURLResponse {
    func validate(data: Data) throws {
        switch self.statusCode {
        case 200...299:
            return

        case 401:
            throw APIError.invalidCredentials

        case 400...499:
            let message = String(data: data, encoding: .utf8) ?? "Request error"
            throw APIError.serverError(message)

        case 500:
            throw APIError.serverError("RegistrationFailed: The email is already in use.")

        case 500...599:
            throw APIError.serverError("Server error, please try again later.")

        default:
            throw APIError.serverError("Unexpected response: \(statusCode)")
        }
    }
}
