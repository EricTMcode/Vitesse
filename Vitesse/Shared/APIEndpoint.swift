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

    var baseURL: String { "http://localhost:8080" }
    
    var path: String {
        switch self {
        case .login: return "/user/auth"
        case .register: return "/user/register"
        case .candidates: return "/candidate"
        }
    }
    
    var method: String {
        switch self {
        case .login: return "POST"
        case .register: return "POST"
        case .candidates: return "GET"
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .login, .register: return false
        case .candidates: return true
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
        }
        
        return request
    }
}
