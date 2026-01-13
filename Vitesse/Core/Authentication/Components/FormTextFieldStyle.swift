//
//  FormTextFieldStyle.swift
//  Vitesse
//
//  Created by Eric on 13/01/2026.
//

import SwiftUI

struct FormTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func formTextFieldStyle() -> some View {
        self.modifier(FormTextFieldStyle())
    }
}
