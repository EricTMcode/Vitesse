//
//  ValidationServiceTests.swift
//  VitesseTests
//
//  Created by Eric on 26/01/2026.
//

import XCTest
@testable import Vitesse

final class ValidationServiceTests: XCTestCase {

    private var service: ValidationService!

    override func setUp() {
        super.setUp()
        service = ValidationService()
    }

    func test_validateEmail_validEmails() {
        let validEmails = [
            "test@vitesse.com",
            "eric.doe@mail.co",
            "user+alias@gmail.com",
            "a.b_c-d%1@test-domain.org"
        ]

        validEmails.forEach {
            XCTAssertTrue(service.validateEmail($0), "Expected \($0) to be valid")
        }
    }

    func test_validateEmail_invalidEmails() {
        let invalidEmails = [
            "",
            "test",
            "test@",
            "@test.com",
            "test@test",
            "test@test.",
            "test@.com",
            "test@com",
            "test@@test.com"
        ]

        invalidEmails.forEach {
            XCTAssertFalse(service.validateEmail($0), "Expected \($0) to be invalid")
        }
    }
}
