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
}
