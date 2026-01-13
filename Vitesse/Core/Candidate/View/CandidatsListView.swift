//
//  CandidatsListView.swift
//  Vitesse
//
//  Created by Eric on 11/01/2026.
//

import SwiftUI

struct CandidatsListView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @StateObject var viewModel = CandidatsListViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Button("Logout") {
                    loginViewModel.logout()
                }
                .buttonStyle(.bordered)

                List(viewModel.candidats) { candidat in
                    Text(candidat.lastName)
                }
            }
            .task {
                await viewModel.getCandidats()
            }
        }

//        VStack(spacing: 30) {
//            Text("Welcome! 🎉")
////
////            Text("Is Admin ? \(authManager.isAdmin ? "Yes" : "No")")
//
//            Button("Logout") {
//                viewModel.logout()
//            }
//            .buttonStyle(.bordered)
//        }
//        .padding()
    }
}

#Preview {
    CandidatsListView(loginViewModel: LoginViewModel(), viewModel: CandidatsListViewModel())
}
