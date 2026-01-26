//
//  APIEndpointTests.swift
//  VitesseTests
//
//  Created by Eric on 26/01/2026.
//

import XCTest
@testable import Vitesse

@MainActor
final class APIEndpointTests: XCTestCase {
    func test_loginRequest() throws {
        let credentials = LoginRequest(email: "test@test.com", password: "1234")
        let endpoint = APIEndpoint.login(credentials: credentials)

        let request = try XCTUnwrap(endpoint.request)

        XCTAssertEqual(request.url?.absoluteString, "http://localhost:8080/user/auth")
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertFalse(endpoint.requiresAuth)

        XCTAssertEqual(
            request.value(forHTTPHeaderField: "Content-Type"),
            "application/json"
        )

        let body = try XCTUnwrap(request.httpBody)
        let decoded = try JSONDecoder().decode(LoginRequest.self, from: body)

        XCTAssertEqual(decoded.email, "test@test.com")
    }

}
