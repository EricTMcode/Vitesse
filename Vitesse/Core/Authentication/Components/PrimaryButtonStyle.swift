//
//  PrimaryButtonStyle.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import SwiftUI

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .frame(width: 360, height: 44)
            .background(Color(.systemBlue))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension View {
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonStyle())
    }
}
