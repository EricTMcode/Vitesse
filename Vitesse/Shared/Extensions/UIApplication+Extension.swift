//
//  UIApplication+Extension.swift
//  Vitesse
//
//  Created by Eric on 19/01/2026.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
