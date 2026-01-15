//
//  RootView.swift
//  Vitesse
//
//  Created by Eric on 11/01/2026.
//

import SwiftUI

struct RootView: View {
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                CandidatesListView(loginViewModel: viewModel)
            } else {
                LoginView(viewModel: viewModel)
            }
        }
        .animation(.default, value: viewModel.isAuthenticated)
    }
}

#Preview {
    RootView()
}
