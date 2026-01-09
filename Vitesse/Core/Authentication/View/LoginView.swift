//
//  LoginView.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                Image(.vitesseLogo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 220, height: 220)
                    .accessibilityLabel("Logo Vitesse")

                TextField("Entrez votre e-mail", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .textFieldModifier()
                    .padding(.bottom, 10)

                SecureField("Mot de passe", text: $viewModel.password)
                    .textFieldModifier()

                Text(viewModel.errorMessage ?? "")
                    .foregroundStyle(.red)
                    .font(.callout)
                    .padding(.top, -1)
                    .opacity(viewModel.errorMessage == nil ? 0 : 1)

                Button {
                    print("DEBUG: Show forgot password")
                } label: {
                    Text("Mot de passe oublié ?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top, -3)
                        .padding(.trailing, 28)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

                Button() {
                    Task { await viewModel.login() }
                } label: {
                    Text("Connexion")
                        .primaryButtonStyle()
                        .overlay {
                            if viewModel.isLoading {
                                ProgressView()
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
