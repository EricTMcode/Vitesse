//
//  RegisterView.swift
//  Vitesse
//
//  Created by Eric on 12/01/2026.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()

    var body: some View {
        Button("register") {
            Task {
                await viewModel.register()
            }
        }
    }
}

#Preview {
    RegisterView()
}
