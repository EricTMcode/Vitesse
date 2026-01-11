//
//  KeychainService.swift
//  Vitesse
//
//  Created by Eric on 11/01/2026.
//

import Security
import Foundation

class KeychainHelper {
    static let shared = KeychainHelper()
    private let service = "com.eric.Vitesse"
    
    // Save data securely
    func save(_ data: Data, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as [CFString: Any]

        // Add to keychain (delete first to ensure we overwrite)
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    // Read data securely
    func read(account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString: Any]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)

        return result as? Data
    }

    // Delete data
    func delete(account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as [CFString: Any]

        SecItemDelete(query as CFDictionary)

        print("DEBUG: Token successfully deleted")
    }
}

