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
//            form

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
                            .autocorrectionDisabled()
                            .focused($focusedField, equals: .email)
                            .onChange(of: viewModel.registerRequest.email) {
                                viewModel.validateEmail()
                            }

                        if let error = viewModel.emailError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
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
    var form: some View {
        VStack(spacing: 16) {
            LabeledTextField(
                title: "Nom",
                placeholder: "Entrez votre nom",
                textContentType: .familyName,
                keyboardType: .default,
                isSecure: false,
                capitalization: .words,
                text: $viewModel.registerRequest.firstName,
                focusedField: $focusedField,
                field: .firstname
            )

            LabeledTextField(
                title: "Prénom",
                placeholder: "Entrez votre Prénom",
                textContentType: .name,
                keyboardType: .default,
                isSecure: false,
                capitalization: .words,
                text: $viewModel.registerRequest.lastName,
                focusedField: $focusedField,
                field: .lastname
            )

            LabeledTextField(
                title: "Email",
                placeholder: "Entrez votre Email",
                textContentType: .emailAddress,
                keyboardType: .emailAddress,
                isSecure: false,
                capitalization: .never,
                text: $viewModel.registerRequest.email,
                focusedField: $focusedField,
                field: .email
            )

            LabeledTextField(
                title: "Mot de passe",
                placeholder: "Entrez votre mot de passe",
                textContentType: .password,
                keyboardType: .default,
                isSecure: true,
                capitalization: .never,
                text: $viewModel.registerRequest.password,
                focusedField: $focusedField,
                field: .password
            )

            LabeledTextField(
                title: "Confirmez votre mot de passe",
                placeholder: "Confirmez votre mot de passe",
                textContentType: .password,
                keyboardType: .default,
                isSecure: true,
                capitalization: .never,
                text: $viewModel.registerRequest.confirmPassword,
                focusedField: $focusedField,
                field: .comfirmPassword
            )
        }
        .padding(.horizontal, 25)
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
        .disabled(!viewModel.isFormValid)
        .opacity(!viewModel.isFormValid ? 0.7 : 1.0)
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

struct LabeledTextField: View {
    let title: String
    let placeholder: String
    let textContentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let capitalization: TextInputAutocapitalization?

    @Binding var text: String
    @FocusState.Binding var focusedField: RegisterView.Field?
    let field: RegisterView.Field

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .textContentType(textContentType)
            .keyboardType(keyboardType)
            .autocorrectionDisabled()
            .textInputAutocapitalization(capitalization)
            .focused($focusedField, equals: field)
        }
    }
}
