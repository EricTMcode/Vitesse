//
//  String+Extension.swift
//  Vitesse
//
//  Created by Eric on 19/01/2026.
//

import Foundation

extension String {
    var formattedShortName: String {
        let parts = self.split(separator: " ")
        guard parts.count >= 2,
              let lastInitial = parts.last?.first
        else {
            return self
        }

        let firstNames = parts.dropLast().joined(separator: " ")
        return "\(firstNames) \(lastInitial)."
    }
}
