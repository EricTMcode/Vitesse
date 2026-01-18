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
        viewModel = RegisterViewModel(service: mockService)
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
}
