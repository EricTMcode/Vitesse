//
//  RegisterView.swift
//  Vitesse
//
//  Created by Eric on 12/01/2026.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @ObservedObject var loginService: LoginViewModel
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
                            .onChange(of: viewModel.registerRequest.password) {
                                viewModel.validatePassword()
                                if !viewModel.registerRequest.confirmPassword.isEmpty {
                                    viewModel.validateConfirmPassword()
                                }
                            }

                            if let error = viewModel.passwordError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            } else {
                                Text("Must include uppercase, lowercase, number, and special character")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
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
                            .onChange(of: viewModel.registerRequest.confirmPassword) {
                                viewModel.validateConfirmPassword()
                            }

                        Text(viewModel.confirmPasswordError ?? " ")
                            .foregroundStyle(.red)
                            .font(.caption)
                            .padding(.top, -1)
                            .opacity(viewModel.confirmPasswordError == nil ? 0 : 1)
                            .animation(.easeInOut(duration: 0.2), value: viewModel.confirmPasswordError)
                            .frame(minHeight: 20)

                            if let error = viewModel.confirmPasswordError {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                    }
                }
            }
            .padding(.horizontal, 25)
            registerButton
            Spacer()
            footer
        }
        .alert("Success", isPresented: $viewModel.isRegistrationSuccessful) {
            Button("OK", role: .cancel) { Task {
                await loginService.login(email: viewModel.registerRequest.email, password: viewModel.registerRequest.password)
            } }
        } message: {
            Text("Account created successfully!")
        }
        .alert(item: $viewModel.errorMessage) { message in
            Alert(title: Text("Error"), message: Text(message.text), dismissButton: .default(Text("OK")))
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
    RegisterView(loginService: LoginViewModel())
}

struct LabeledTextField: View {
    let title: String
    let placeholder: String
    let isSecure: Bool

    let textContentType: UITextContentType?
    let keyboardType: UIKeyboardType
    let capitalization: TextInputAutocapitalization?
    let autocorrectionDisabled: Bool

    let helperText: String?
    let errorText: String?

    let onChange: ((String) -> Void)?

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
            .autocorrectionDisabled(autocorrectionDisabled)
            .textInputAutocapitalization(capitalization)
            .focused($focusedField, equals: field)
            .onChange(of: text) { value in
                onChange?(value)
            }

            if let errorText {
                Text(errorText)
                    .font(.caption)
                    .foregroundColor(.red)
            } else if let helperText {
                Text(helperText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
