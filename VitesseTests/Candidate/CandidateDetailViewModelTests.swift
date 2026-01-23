//
//  CandidateDetailViewModelTests.swift
//  VitesseTests
//
//  Created by Eric on 23/01/2026.
//

import XCTest
@testable import Vitesse

@MainActor
final class CandidateDetailViewModelTests: XCTestCase {
    var viewModel: CandidateDetailViewModel!
    var mockService: MockCandidateUpdateService!

    override func setUp() {
        super.setUp()
        mockService = MockCandidateUpdateService()

        let candidate = mockCandidates.first!

        viewModel = CandidateDetailViewModel(service: mockService, candidate: candidate)
    }

    override func tearDown() {
        mockService = nil
        viewModel = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(viewModel, "The vie model should not be nil")
    }

    func test_startEditing_setsDraftAndEditingState() {
        viewModel.startEditing()

        XCTAssertTrue(viewModel.isEditing)
        XCTAssertNotNil(viewModel.draftCandidate)
        XCTAssertEqual(viewModel.draftCandidate?.email, viewModel.candidate.email)
    }

    func test_cancelEditing_resetsDraftAndError() {
        viewModel.startEditing()
        viewModel.errorMessage = "Error"

        viewModel.cancelEditing()

        XCTAssertFalse(viewModel.isEditing)
        XCTAssertNil(viewModel.draftCandidate)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_saveChanges_success_updatesCandidate() async {
        viewModel.startEditing()
        viewModel.draftCandidate?.email = "new@vitesse.com"

        await viewModel.saveChanges()

        XCTAssertTrue(mockService.updateCandidateCalled)
        XCTAssertEqual(viewModel.candidate.email, "new@vitesse.com")
        XCTAssertFalse(viewModel.isEditing)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_saveChanges_failure_setsErrorMessage() async {
        mockService.updateCandidateError = NSError(domain: "Test", code: 1)

        viewModel.startEditing()
        viewModel.draftCandidate?.email = "fail@vitesse.com"

        await viewModel.saveChanges()

        XCTAssertTrue(mockService.updateCandidateCalled)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.isEditing)
        XCTAssertFalse(viewModel.isLoading)
    }
}
