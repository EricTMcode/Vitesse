//
//  LoginViewModelTests.swift
//  VitesseTests
//
//  Created by Eric on 11/01/2026.
//

import XCTest
@testable import Vitesse

@MainActor
final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!
    var mockService: MockLoginService!

    override func setUp() {
        super.setUp()
        mockService = MockLoginService()
        viewModel = LoginViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(viewModel, "The view model should not be nil")
    }

    func test_login_success_setsAuthenticatedTrue() async {
        mockService.resultToReturn = .success(())

        viewModel.email = "test@vitesse.com"
        viewModel.password = "123456"

        await viewModel.login()

        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertEqual(mockService.lastReceivedRequest?.email, "test@vitesse.com")
    }

    func test_login_failure_setsErrorMessage() async {
        let expectedErrorMessage = APIError.invalidCredentials
        mockService.resultToReturn = .failure(expectedErrorMessage)

        await viewModel.login()

        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func test_logout_resetsAuthentication() {
        viewModel.logout()

        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertTrue(mockService.didLogout)
    }

    func test_formIsValid_withEmailAndPassword_returnsTrue() {
        viewModel.email = "test@vitesse.com"
        viewModel.password = "12345678"

        XCTAssertTrue(viewModel.formIsValid)
    }

    func test_formIsValid_withInvalidEmail_returnFalse() {
        viewModel.email = "testvitesse-com"
        viewModel.password = "123"

        XCTAssertFalse(viewModel.formIsValid)
    }

    func test_formIsValid_withShortPassword_returnFalse() {
        viewModel.email = "test@vitesse.com"
        viewModel.password = "123"

        XCTAssertFalse(viewModel.formIsValid)
    }

    func test_login_failure_doesNotAuthenticateUser() async {
        // GIVEN
        mockService.resultToReturn = .failure(APIError.invalidCredentials)

        viewModel.email = "test@vitesse.com"
        viewModel.password = "wrongpass"

        // WHEN
        await viewModel.login()

        // THEN
        XCTAssertFalse(viewModel.isAuthenticated)
    }

    func test_login_clearsPreviousErrorBeforeNewAttempt() async {
        // Error login attempt
        mockService.resultToReturn = .failure(APIError.invalidCredentials)

        viewModel.email = "test@vitesse.com"
        viewModel.password = "wrongpass"

        await viewModel.login()
        XCTAssertNotNil(viewModel.errorMessage)

        // Login success attempt
        mockService.resultToReturn = .success(())

        await viewModel.login()

        XCTAssertNil(viewModel.errorMessage)
    }
}
