//
//  URLSessionProtocol.swift
//  Vitesse
//
//  Created by Eric on 25/01/2026.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
