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

    func test_validatePassword_failsIfTooShort() {
        XCTAssertFalse(service.validatePassword("Ab1!"))
    }

    func test_validatePassword_failsIfMissingUppercase() {
        XCTAssertFalse(service.validatePassword("abc123!"))
    }

    func test_validatePassword_failsIfMissingLowercase() {
        XCTAssertFalse(service.validatePassword("ABC123!"))
    }

    func test_validatePassword_failsIfMissingNumber() {
        XCTAssertFalse(service.validatePassword("Abcdef!"))
    }

    func test_validatePassword_failsIfMissingSpecialCharacter() {
        XCTAssertFalse(service.validatePassword("Abc1234"))
    }

    func test_validatePassword_validPassword() {
        XCTAssertTrue(service.validatePassword("Abc123!"))
    }

    func test_validatePasswordsMatch_success() {
        XCTAssertTrue(service.validatePasswordsMatch("Abc123!", "Abc123!"))
    }

    func test_validatePasswordsMatch_failure() {
        XCTAssertFalse(service.validatePasswordsMatch("Abc123!", "Abc1234!"))
    }

    func test_validatePasswordsMatch_failsIfEmpty() {
        XCTAssertFalse(service.validatePasswordsMatch("", ""))
    }
}
