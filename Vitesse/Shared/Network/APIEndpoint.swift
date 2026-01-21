//
//  APIEndpoint.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import Foundation

enum APIEndpoint {
    case login(credentials: LoginRequest)
    case register(user: User)
    case candidates
    case deleteCandidate(id: String)
    case updateCandidate(data: Candidate)
    case favoriteCandidate(id: String)

    var baseURL: String { "http://localhost:8080" }
    
    var path: String {
        switch self {
        case .login: return "/user/auth"
        case .register: return "/user/register"
        case .candidates: return "/candidate"
        case .deleteCandidate(let id): return "/candidate/\(id)"
        case .updateCandidate(let candidate): return "/candidate/\(candidate.id)"
        case .favoriteCandidate(let id): return "/candidate/\(id)/favorite"
        }
    }
    
    var method: String {
        switch self {
        case .login: return "POST"
        case .register: return "POST"
        case .candidates: return "GET"
        case .deleteCandidate: return "DELETE"
        case .updateCandidate: return "PUT"
        case .favoriteCandidate: return "PUT"
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .login, .register: return false
        case .candidates, .deleteCandidate, .updateCandidate, .favoriteCandidate: return true
        }
    }

    var hasBody: Bool {
        switch self {
        case .login, .register, .updateCandidate:
            return true
        default:
            return false
        }
    }

    var request: URLRequest? {
        guard let url = URL(string: baseURL + path) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .login(let credentials):
            request.httpBody = try? JSONEncoder().encode(credentials)
        case .register(let user):
            request.httpBody = try? JSONEncoder().encode(user)
        case .candidates:
            break
        case .deleteCandidate(let id):
            request.httpBody = try? JSONEncoder().encode(id)
        case .updateCandidate(let data):
            request.httpBody = try? JSONEncoder().encode(data)
        case .favoriteCandidate(let id):
            request.httpBody = try? JSONEncoder().encode(id)
        }
        
        return request
    }
}
