//
//  RegisterView.swift
//  Vitesse
//
//  Created by Eric on 12/01/2026.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    enum Field {
        case firstname, lastname, email, password, comfirmPassword
    }

    var body: some View {
        VStack {
            header
            VStack(spacing: 16) {

                VStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nom")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        TextField("Entrez votre Nom", text: $viewModel.registerRequest.firstName)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.familyName)
                            .focused($focusedField, equals: .firstname)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Prémom")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        TextField("Entrez votre Prénom", text: $viewModel.registerRequest.lastName)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.name)
                            .focused($focusedField, equals: .lastname)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        TextField("Entrer votre Email", text: $viewModel.registerRequest.email)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .email)
                        //                            .onChange(of: viewModel.registerRequest.email) { _ in
                        //                                viewModel.validateEmail()
                        //                            }

                        //                        if let error = viewModel.emailError {
                        //                            Text(error)
                        //                                .font(.caption)
                        //                                .foregroundColor(.red)
                        //                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mot de passe")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        SecureField("Entrez votre mot de passe", text: $viewModel.registerRequest.password)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .textInputAutocapitalization(.never)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Confirmation mot de passe")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        SecureField("Confirmez votre mot de passe", text: $viewModel.registerRequest.confirmPassword)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.password)
                            .focused($focusedField, equals: .comfirmPassword)
                            .textInputAutocapitalization(.never)
                    }
                }
            }
            .padding(.horizontal, 25)
            registerButton
            Spacer()
            footer
        }

    }
}

private extension RegisterView {
    var header: some View {
        VStack {
            Image(.vitesseLogo)
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 120)
                .accessibilityLabel("Vitesse Logo")

            Text("Enregistrez-vous")
                .font(.title2.bold())
                .padding(.bottom, 30)
        }
    }
}

private extension RegisterView {
    var registerButton: some View {
        Button {
            Task { await viewModel.register() }
        } label: {
            Text("Créez votre compte")
                .primaryButtonStyle()
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
        }
        .padding(.vertical)
        .padding(.top, 10)
    }
}

private extension RegisterView {
    var footer: some View {
        VStack {
            Divider()

            Button {
                dismiss()
            } label: {
                Text("Vous avez déjà un compte ? **Connectez-vous**")
                    .font(.footnote)
            }
            .padding(.vertical, 16)
        }
    }
}


#Preview {
    RegisterView()
}
