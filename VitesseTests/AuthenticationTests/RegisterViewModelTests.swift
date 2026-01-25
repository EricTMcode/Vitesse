//
//  RegisterViewModelTests.swift
//  VitesseTests
//
//  Created by Eric on 18/01/2026.
//

import XCTest
@testable import Vitesse

@MainActor
final class RegisterViewModelTests: XCTestCase {
    var viewModel: RegisterViewModel!
    var mockService: MockRegisterService!

    override func setUp() {
        super.setUp()
        mockService = MockRegisterService()
        viewModel = RegisterViewModel(service: mockService, validationService: ValidationService())
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(viewModel, "The view model should not be nil")
    }

    func test_register_success_sets_Registration_Success() async {
        // Given
        mockService.resultToReturn = .success(())

        viewModel.registerRequest = User(
            firstName: "Eric",
            lastName: "Dupont",
            email: "eric@test.com",
            password: "Password1!",
            confirmPassword: "Password1!"
        )

        // When
        await viewModel.register()

        // Then
        XCTAssertTrue(viewModel.isRegistrationSuccessful)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(mockService.lastReveivedUser?.email, "eric@test.com")
    }

    func test_register_failure_if_isFormValide_False() async {
        // When
        await viewModel.register()

        // Then
        XCTAssertFalse(viewModel.isRegistrationSuccessful)
    }

    func test_isFormValid_whenAllFieldsAreEmpty_isFalse() {
        XCTAssertFalse(viewModel.isFormValid)
    }

    func test_isFormValid_whenFirstNameIsEmpty_isFalse() {
        // When
        viewModel.registerRequest = User(
            firstName: "",
            lastName: "Dupont",
            email: "eric@test.com",
            password: "Password1!",
            confirmPassword: "Password1!"
        )
        // Then
        XCTAssertFalse(viewModel.isFormValid)
    }

    func test_isFormValid_whenEmailsIsInvalid_isFalse() {
        // When
        viewModel.registerRequest = User(
            firstName: "Eric",
            lastName: "Dupont",
            email: "eric,test.com",
            password: "Password1!",
            confirmPassword: "Password1!"
        )

        // Then
        XCTAssertFalse(viewModel.isFormValid)
    }

    func test_isFormValid_whenPasswordIsWeak_isFalse() {
        // When
        viewModel.registerRequest = User(
            firstName: "Eric",
            lastName: "Dupont",
            email: "eric@test.com",
            password: "password1",
            confirmPassword: "password1"
        )

        // Then
        XCTAssertFalse(viewModel.isFormValid)
    }

    func test_register_withInvalidForm_doesNotSucceed() async {
        // Given
        mockService.resultToReturn = .failure(APIError.invalidResponse)

        // When
        viewModel.registerRequest = User(
            firstName: "",
            lastName: "",
            email: "null",
            password: "789",
            confirmPassword: "123!"
        )

        await viewModel.register()

        // Then
        XCTAssertFalse(viewModel.isRegistrationSuccessful)
    }
}
