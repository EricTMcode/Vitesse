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

        let email = "test@vitesse.com"
        let password = "123456"

        await viewModel.login(email: email, password: password)

        XCTAssertTrue(viewModel.isAuthenticated)
        XCTAssertEqual(mockService.lastReceivedRequest?.email, "test@vitesse.com")
    }

    func test_login_failure_setsErrorMessage() async {
        let expectedErrorMessage = APIError.invalidCredentials
        mockService.resultToReturn = .failure(expectedErrorMessage)

        let email = "test-vitesse-com"
        let password = "123456"

        await viewModel.login(email: email, password: password)

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

        let email = "test@vitesse.com"
        let password = "wrongpass"

        // WHEN
        await viewModel.login(email: email, password: password)

        // THEN
        XCTAssertFalse(viewModel.isAuthenticated)
    }

    func test_login_clearsPreviousErrorBeforeNewAttempt() async {
        // Error login attempt
        mockService.resultToReturn = .failure(APIError.invalidCredentials)

        let email = "test@vitesse.com"
        let password = "wrongpass"

        await viewModel.login(email: email, password: password)
        XCTAssertNotNil(viewModel.errorMessage)

        // Login success attempt
        mockService.resultToReturn = .success(())

        let goodEmail = "test@vitesse.com"
        let goodPassword = "123456"

        await viewModel.login(email: goodEmail, password: goodPassword)

        XCTAssertNil(viewModel.errorMessage)
    }
}
