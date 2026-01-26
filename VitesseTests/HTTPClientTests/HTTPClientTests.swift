//
//  HTTPClientTests.swift
//  VitesseTests
//
//  Created by Eric on 25/01/2026.
//

import XCTest
@testable import Vitesse

@MainActor
final class HTTPClientTests: XCTestCase {

    func test_fetchData_success_decodesJSON() async throws {
        let session = MockURLSession()
        let keychain = MockKeychainHelper(token: nil)
        let client = HTTPClient(session: session, keychain: keychain)

        let json = """
            { "email": "test@vitesse.com", "password": "1234" }
            """.data(using: .utf8)!

        session.data = json
        session.response = HTTPURLResponse(
            url: URL(string: "http://localhost")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let result: LoginRequest = try await client.fetchData(.login(credentials: .init(email: "", password: "")))

        XCTAssertEqual(result.email, "test@vitesse.com")
    }

    func test_authHeader_added_whenEndpointRequiersAuth() async throws {
        let session = MockURLSession()
        let keychain = MockKeychainHelper(token: "token123")
        let client = HTTPClient(session: session, keychain: keychain)

        session.data = Data()
        session.response = HTTPURLResponse(
            url: URL(string: "http://localhost")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        try await client.perform(.candidates)

        let header = session.lastRequest?
            .value(forHTTPHeaderField: "Authorization")

        XCTAssertEqual(header, "Bearer token123")
    }

    func test_authHeader_notAdded_forPublicEndpoint() async throws {
        let session = MockURLSession()
        let keychain = MockKeychainHelper(token: "token123")
        let client = HTTPClient(session: session, keychain: keychain)

        session.data = Data()
        session.response = HTTPURLResponse(
            url: URL(string: "http://localhost")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        try await client.perform(.login(credentials: .init(email: "", password: "")))

        let header = session.lastRequest?
            .value(forHTTPHeaderField: "Authorization")

        XCTAssertNil(header)
    }

    



}
