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
            Image(.vitesseLogo)
                .resizable()
                .scaledToFill()
                .frame(width: 220, height: 120)
                .accessibilityLabel("Vitesse Logo")

            VStack(spacing: 16) {
                Text("Enregistrez-vous")
                    .font(.title2.bold())
                    .padding(.bottom, 30)

                VStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("First Name")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        TextField("Enter your first name", text: $viewModel.registerRequest.firstName)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.familyName)
                            .focused($focusedField, equals: .firstname)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Last Name")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        TextField("Enter your last name", text: $viewModel.registerRequest.lastName)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.familyName)
                            .focused($focusedField, equals: .lastname)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        TextField("Enter your email", text: $viewModel.registerRequest.email)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
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
                        Text("Password")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        SecureField("Entrez votre mot de passe", text: $viewModel.registerRequest.password)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.password)
                            .focused($focusedField, equals: .password)
                            .autocapitalization(.none)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Password")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        SecureField("Confirmez votre mot de passe", text: $viewModel.registerRequest.confirmPassword)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.password)
                            .focused($focusedField, equals: .comfirmPassword)
                            .autocapitalization(.none)
                    }

                }

                    
            }
            .padding(.horizontal, 25)
        }

        Button {
            Task {
                await viewModel.register()
            }
        } label: {
            Text("Creez votre compte")
                .primaryButtonStyle()
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
        }
        .padding(.vertical)
        .padding(.top, 10)

        Spacer()

        Divider()

        Button {
            dismiss()
        } label: {
            Text("Vous avez-déjà un compte ? **Connectez-vous**")
                .font(.footnote)
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    RegisterView()
}
