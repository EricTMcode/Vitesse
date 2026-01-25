//
//  MockURLSession.swift
//  Vitesse
//
//  Created by Eric on 25/01/2026.
//

import Foundation

final class MockURLSession: URLSessionProtocol {
    var data: Data = Data()
    var response: URLResponse?
    var error: Error?

    private(set) var lastRequest: URLRequest?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        lastRequest = request

        if let error {
            throw error
        }
        
        guard let response else {
            throw APIError.invalidResponse
        }

        return (data, response)
    }
}
