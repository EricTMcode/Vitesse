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



}
