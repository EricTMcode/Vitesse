//
//  EditTextFieldStyle.swift
//  Vitesse
//
//  Created by Eric on 23/01/2026.
//

import SwiftUI

struct EditTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .padding(4)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func editTextFieldStyle() -> some View {
        self.modifier(EditTextFieldStyle())
    }
}
