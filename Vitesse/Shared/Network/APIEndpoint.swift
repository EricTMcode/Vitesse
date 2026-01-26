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
    case toogleFavorite(id: String)

    var baseURL: String { "http://localhost:8080" }
    
    var path: String {
        switch self {
        case .login: return "/user/auth"
        case .register: return "/user/register"
        case .candidates: return "/candidate"
        case .deleteCandidate(let id): return "/candidate/\(id)"
        case .updateCandidate(let candidate): return "/candidate/\(candidate.id)"
        case .toogleFavorite(let id): return "/candidate/\(id)/favorite"
        }
    }
    
    var method: String {
        switch self {
        case .login: return "POST"
        case .register: return "POST"
        case .candidates: return "GET"
        case .deleteCandidate: return "DELETE"
        case .updateCandidate: return "PUT"
        case .toogleFavorite: return "POST"
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .login, .register: return false
        case .candidates, .deleteCandidate, .updateCandidate, .toogleFavorite: return true
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

        if hasBody {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        switch self {
        case .login(let credentials):
            do {
                request.httpBody = try JSONEncoder().encode(credentials)
            } catch {
                assertionFailure("Encoding failed: \(error)")
            }
        case .register(let user):
            do {
                request.httpBody = try JSONEncoder().encode(user)
            } catch {
                assertionFailure("Encoding failed: \(error)")
            }
        case .candidates:
            break
        case .deleteCandidate:
            break
        case .updateCandidate(let data):
            do {
                request.httpBody = try JSONEncoder().encode(data)
            } catch {
                assertionFailure("Encoding failed: \(error)")
            }
        case .toogleFavorite(let id):
            do {
                request.httpBody = try JSONEncoder().encode(id)
            } catch {
                assertionFailure("Encoding failed: \(error)")
            }
        }
        
        return request
    }
}
