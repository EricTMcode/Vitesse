//
//  TextFieldModifier.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .padding(.horizontal, 12)
            .padding(.trailing, 32)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 24)
    }
}

extension View {
    func textFieldModifier() -> some View {
        modifier(TextFieldModifier())
    }
}
