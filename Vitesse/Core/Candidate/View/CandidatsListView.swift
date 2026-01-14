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
                            HStack {
                                Text("\(candidat.firstName) \(candidat.lastName)")

                                Spacer()

                                Image(systemName: candidat.isFavorite ? "star.fill" : "star")
                                    .imageScale(.large)
                                    .foregroundColor(.yellow)
                            }
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button ("Edit") {
                        viewModel.showIsEditing.toggle()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.showIsEditing {
                        Button("Effacer") {

                        }
                    } else {
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                viewModel.showIsFavorite.toggle()
                               }
                        } label: {
                            Image(systemName: viewModel.showIsFavorite ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }

            .task {
                await viewModel.getCandidats()
            }
        }
    }
}

#Preview {
    CandidatsListView(loginViewModel: LoginViewModel(), viewModel: CandidatsListViewModel(service: MockCandidateService()))
}
