//
//  GradientCircleView.swift
//  Vitesse
//
//  Created by Eric on 26/01/2026.
//

import SwiftUI

struct GradientCircleView: View {
    var size: CGFloat
    var colors: [Color] = [
        Color.blue.opacity(0.6),
        Color.purple.opacity(0.6)
    ]

    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
    }

}
