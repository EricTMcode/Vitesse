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

    func test_login_success_setsUserToken() async {
        let expectedToken = "abc-123-token"
        let mockResponse = AuthResponse(token: expectedToken, isAdmin: true)
        mockService.resultToReturn = Result<AuthResponse, Error>.success(mockResponse)

        viewModel.email = "test@vitesse.com"
        viewModel.password = "Test123"

        await viewModel.login()

        XCTAssertEqual(viewModel.userToken, expectedToken)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)

        XCTAssertEqual(mockService.lastReceivedRequest?.email, "test@vitesse.com")
        XCTAssertEqual(mockService.lastReceivedRequest?.password, "Test123")
    }

    func test_login_failure_setsErrorMessage() async {
        let expectedErrorMessage = APIError.invalidCredentials
        mockService.resultToReturn = Result<AuthResponse, Error>.failure(expectedErrorMessage)

        viewModel.email = "wrong@vitesse.com"
        viewModel.password = "wrongpass"

        await viewModel.login()

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Email or password incorrect")
        XCTAssertNil(viewModel.userToken)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_formIsValid_withEmailAndPassword_returnsTrue() {
        viewModel.email = "test@vitesse.com"
        viewModel.password = "123456"

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

    func test_login_success_setsIsAuthenticatedTrue() async {
        mockService.resultToReturn = .success(AuthResponse(token: "token", isAdmin: false))

        viewModel.email = "test@vitesse.com"
        viewModel.password = "123456"
        
        await viewModel.login()
        
        XCTAssertTrue(viewModel.isAuthenticated)
    }
}
