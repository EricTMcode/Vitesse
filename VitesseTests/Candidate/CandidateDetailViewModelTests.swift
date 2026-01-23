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


}
