//
//  MockRegisterService.swift
//  Vitesse
//
//  Created by Eric on 17/01/2026.
//

import Foundation

final class MockRegisterService: RegisterServiceProtocol {
    var resultToReturn: Result<Void, Error>?

    private(set) var lastReveivedUser: User?


    func register(with request: User) async throws {
        lastReveivedUser = request

        switch resultToReturn {
        case .success:
            return
        case .failure(let error):
            throw error
        case .none:
            fatalError("Result to return was not set in test setup")
        }
    }

}
