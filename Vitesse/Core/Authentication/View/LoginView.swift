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
                
                Text(viewModel.errorMessage ?? " ")
                    .foregroundStyle(.red)
                    .font(.callout)
                    .padding(.top, -1)
                    .opacity(viewModel.errorMessage == nil ? 0 : 1)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.errorMessage)
                    .frame(minHeight: 20)
                
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
                .disabled(!viewModel.formIsValid)
                .opacity(!viewModel.formIsValid ? 0.7 : 1.0)
                .padding(.vertical)
                .padding(.top, 10)
                
                CustomSeparatorView()
                
                NavigationLink {
                    RegisterView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Creer un compte")
                        .primaryButtonStyle()
                }
                .padding(.vertical, 16)
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    RegisterView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Pas de compte ? **Inscrivez-vous**")
                        .font(.footnote)
                }
                .padding(.vertical, 16)
            }
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}

struct CustomSeparatorView: View {
    var body: some View {
        GeometryReader { proxy in
            let width = (proxy.size.width / 2) - 40
            HStack {
                Rectangle()
                    .frame(width: width, height: 0.5)
                
                Text("ou")
                    .font(.footnote)
                    .fontWeight(.semibold)
                
                Rectangle()
                    .frame(width: width, height: 0.5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .foregroundStyle(.gray)
        }
        .frame(height: 20)
    }
}
