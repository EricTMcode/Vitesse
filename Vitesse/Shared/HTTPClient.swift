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
