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
            form
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
            // FirstName Field
            VStack(alignment: .leading, spacing: 4) {
                Text("Nom")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                TextField("Entrez votre nom", text: $viewModel.registerRequest.firstName)
                    .formTextFieldStyle()
                    .textContentType(.familyName)
                    .focused($focusedField, equals: .firstname)
            }

            // LastName Field
            VStack(alignment: .leading, spacing: 4) {
                Text("Prénom")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                TextField("Entrez votre prénom", text: $viewModel.registerRequest.lastName)
                    .formTextFieldStyle()
                    .textContentType(.name)
                    .focused($focusedField, equals: .lastname)
            }

            // Email Field
            VStack(alignment: .leading, spacing: 4) {
                Text("Email")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                TextField("Entrez votre email", text: $viewModel.registerRequest.email)
                    .formTextFieldStyle()
                    .textContentType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.registerRequest.email) {
                        viewModel.validateEmail()
                    }

                if let error = viewModel.emailError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }

            // Password Field
            VStack(alignment: .leading, spacing: 4) {
                Text("Mot de passe")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                SecureField("Entrez votre mot de passe", text: $viewModel.registerRequest.password)
                    .formTextFieldStyle()
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onChange(of: viewModel.registerRequest.password) {
                        viewModel.validatePassword()
                        if !viewModel.registerRequest.confirmPassword.isEmpty {
                            viewModel.validateConfirmPassword()
                        }
                    }

                if let error = viewModel.passwordError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                } else {
                    Text("Must include uppercase, lowercase, number, and special character")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Confirm Password Field
            VStack(alignment: .leading, spacing: 4) {
                Text("Confirmation mot de passe")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                SecureField("Confirmez votre mot de passe", text: $viewModel.registerRequest.confirmPassword)
                    .formTextFieldStyle()
                    .textContentType(.newPassword)
                    .focused($focusedField, equals: .comfirmPassword)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
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
            }
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
//        .padding(.vertical)
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
