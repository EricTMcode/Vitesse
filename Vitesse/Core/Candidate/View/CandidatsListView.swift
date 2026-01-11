//
//  CandidatsListView.swift
//  Vitesse
//
//  Created by Eric on 11/01/2026.
//

import SwiftUI

struct CandidatsListView: View {
    @ObservedObject var viewModel: LoginViewModel
    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome! 🎉")

            Text("JWT Token: \(viewModel.userToken ?? "none")")
                .font(.caption)
                .foregroundColor(.gray)
//
//            Text("Is Admin ? \(authManager.isAdmin ? "Yes" : "No")")

            Button("Logout") {
                viewModel.logout()
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

#Preview {
    CandidatsListView(viewModel: LoginViewModel())
}
