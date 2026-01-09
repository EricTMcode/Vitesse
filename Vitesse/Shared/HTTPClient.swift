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
    func fetchData<T>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.request else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(for: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }
    }
    
    func perform(_ endpoint: APIEndpoint) async throws {
        <#code#>
    }
    

}
