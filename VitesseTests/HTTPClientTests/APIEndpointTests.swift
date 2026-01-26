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

    func test_candidatesRequest() throws {
        let endpoint = APIEndpoint.candidates
        let request = try XCTUnwrap(endpoint.request)

        XCTAssertEqual(request.url?.absoluteString, "http://localhost:8080/candidate")
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(endpoint.requiresAuth)
        XCTAssertNil(request.httpBody)
    }

    func test_updateCandidateRequest() throws {
        let candidate = Candidate(
            id: "123",
            firstName: "Eric",
            lastName: "Dupont",
            email: "e@test.com",
            phone: nil,
            linkedinURL: nil,
            isFavorite: false,
            note: nil
        )

        let endpoint = APIEndpoint.updateCandidate(data: candidate)
        let request = try XCTUnwrap(endpoint.request)

        XCTAssertEqual(request.httpMethod, "PUT")
        XCTAssertEqual(
            request.url?.absoluteString,
            "http://localhost:8080/candidate/123"
        )

        let body = try XCTUnwrap(request.httpBody)
        let decoded = try JSONDecoder().decode(Candidate.self, from: body)

        XCTAssertEqual(decoded.email, "e@test.com")
    }

    func test_toggleFavoriteRequest() throws {
        let endpoint = APIEndpoint.toogleFavorite(id: "abc")
        let request = try XCTUnwrap(endpoint.request)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(
            request.url?.absoluteString,
            "http://localhost:8080/candidate/abc/favorite"
        )
        XCTAssertTrue(endpoint.requiresAuth)
    }

    func test_deleteCandidateRequest() throws {
        let endpoint = APIEndpoint.deleteCandidate(id: "42")
        let request = try XCTUnwrap(endpoint.request)

        XCTAssertEqual(request.httpMethod, "DELETE")
        XCTAssertEqual(
            request.url?.absoluteString,
            "http://localhost:8080/candidate/42"
        )
    }
}
