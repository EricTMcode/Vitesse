//
//  CandidatesListViewModelTests.swift
//  VitesseTests
//
//  Created by Eric on 22/01/2026.
//

import XCTest
@testable import Vitesse

@MainActor
final class CandidatesListViewModelTests: XCTestCase {
    var viewModel: CandidatesListViewModel!
    var mockService: MockCandidateService!

    override func setUp() {
        super.setUp()
        mockService = MockCandidateService()
        viewModel = CandidatesListViewModel(service: mockService)
    }

    override func tearDown() {
        mockService = nil
        viewModel = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(viewModel, "The view model should not be nil")
    }

    func test_getCandidates_returnsMockedData() async {
        // WHEN
        await viewModel.getCandidates()

        // THEN
        XCTAssertEqual(viewModel.candidates.count, 10)
        XCTAssertEqual(viewModel.candidates.first?.firstName, "Alice")
        XCTAssertEqual(viewModel.loadingState, .completed)
    }

    func test_getCandidates_success_setsCompletedState() async {
        // GIVEN
        mockService.candidatesToReturn = [
            Candidate(id: "1", firstName: "Eric", lastName: "Dupont", email: "", isFavorite: false),
            Candidate(id: "2", firstName: "Anna", lastName: "Martin", email: "", isFavorite: true)
        ]

        // WHEN
        await viewModel.getCandidates()

        // THEN
        XCTAssertEqual(viewModel.candidates.count, 2)
        XCTAssertEqual(viewModel.loadingState, .completed)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_getCandidates_empty_setsEmptyState() async {
        // GIVEN
        mockService.candidatesToReturn = []

        // WHEN
        await viewModel.getCandidates()

        // THEN
        XCTAssertTrue(viewModel.candidates.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .empty)
    }

    func test_getCandidates_failure_setsErrorState() async {
        let mockService = MockCandidateService()
        mockService.getCandidatesError = APIError.networkError

        let viewModel = CandidatesListViewModel(service: mockService)

        await viewModel.getCandidates()

        switch viewModel.loadingState {
        case .error:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected error state")
        }
    }

    func test_deleteCandidates_deletesSelectedCandidates() async {
        // GIVEN
        mockService.candidatesToReturn = [
            Candidate(id: "1", firstName: "Eric", lastName: "Dupont", email: "", isFavorite: false),
            Candidate(id: "2", firstName: "Anna", lastName: "Martin", email: "", isFavorite: false)
        ]

        await viewModel.getCandidates()

        viewModel.selectedCandidate = ["1", "2"]
        viewModel.showIsEditing = true

        // WHEN
        await viewModel.deleteCandidates()

        // THEN
        XCTAssertEqual(mockService.deletedCandidateIDs.sorted(), ["1", "2"])
        XCTAssertFalse(viewModel.showIsEditing)
        XCTAssertTrue(viewModel.selectedCandidate.isEmpty)
        XCTAssertEqual(viewModel.loadingState, .completed)
    }

    func test_deleteCandidates_failure_setsErrorState() async {
        mockService.deleteCandidateError = APIError.networkError

        viewModel.selectedCandidate = ["1"]

        await viewModel.deleteCandidates()

        switch viewModel.loadingState {
        case .error:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected error state")
        }
    }

    func test_filteredCandidates() async {
        // GIVEN
        await viewModel.getCandidates()

        viewModel.searchText = "durand"

        // WHEN
        let result = viewModel.filteredCandidats

        // THEN
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "2")
    }

    func test_filteredCandidates_filtersByFavoriteAndSearch() async {
        // GIVEN
        await viewModel.getCandidates()

        viewModel.showIsFavorite = true
        viewModel.searchText = "alice"

        // WHEN
        let result = viewModel.filteredCandidats

        // THEN
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "1")
    }
}
