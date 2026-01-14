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
                List {
                    ForEach(viewModel.filteredCandidats) { candidat in
                        VStack(alignment: .leading) {
                            Text("\(candidat.firstName) \(candidat.lastName)")
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $viewModel.searchText, prompt: "Rechercher un candidat")

                Button("Logout") {
                    loginViewModel.logout()
                }
                .buttonStyle(.bordered)
            }
            .navigationTitle("Candidtats")
            .navigationBarTitleDisplayMode(.inline)

            .task {
                await viewModel.getCandidats()
            }
        }
    }
}

#Preview {
    CandidatsListView(loginViewModel: LoginViewModel(), viewModel: CandidatsListViewModel(service: MockCandidateService()))
}
