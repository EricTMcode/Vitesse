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
        .alert(AuthenticationStrings.RegisterView.success.capitalized, isPresented: $viewModel.isRegistrationSuccessful) {
            Button(AuthenticationStrings.RegisterView.ok.uppercased(), role: .cancel) { Task {
                await loginService.login(email: viewModel.registerRequest.email, password: viewModel.registerRequest.password)
                dismiss()
                viewModel.reset()
            } }
        } message: {
            Text(AuthenticationStrings.RegisterView.accountCreatedSuccessfully)
        }
        .alert(item: $viewModel.errorMessage) { message in
            Alert(title: Text(AuthenticationStrings.RegisterView.error.uppercased()), message: Text(message.text), dismissButton: .default(Text(AuthenticationStrings.RegisterView.ok.uppercased())))
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
                .accessibilityLabel(AuthenticationStrings.Common.accessibilityLabelLogo)

            Text(AuthenticationStrings.RegisterView.registerTitle.capitalized)
                .font(.title2.bold())
                .padding(.bottom, 30)
        }
    }
}

private extension RegisterView {
    var form: some View {
        VStack(spacing: 10) {
            // FirstName Field
            VStack(alignment: .leading, spacing: 4) {
                FormLabel(title: AuthenticationStrings.RegisterView.firstName.capitalized)

                TextField(AuthenticationStrings.RegisterView.firstNameField, text: $viewModel.registerRequest.firstName)
                    .formTextFieldStyle()
                    .textContentType(.familyName)
                    .focused($focusedField, equals: .firstname)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .lastname }
            }

            // LastName Field
            VStack(alignment: .leading, spacing: 4) {
                FormLabel(title: AuthenticationStrings.RegisterView.lastName.capitalized)

                TextField(AuthenticationStrings.RegisterView.lastNameField, text: $viewModel.registerRequest.lastName)
                    .formTextFieldStyle()
                    .textContentType(.name)
                    .padding(.top, 5)
                    .focused($focusedField, equals: .lastname)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .email }
            }

            // Email Field
            VStack(alignment: .leading, spacing: 4) {
                FormLabel(title: AuthenticationStrings.RegisterView.email.capitalized)

                TextField(AuthenticationStrings.RegisterView.emailField, text: $viewModel.registerRequest.email)
                    .formTextFieldStyle()
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }
                    .padding(.top, 5)
                    .onChange(of: viewModel.registerRequest.email) {
                        viewModel.validateEmail()
                    }

                Text(viewModel.emailError ?? " ")
                    .foregroundStyle(.red)
                    .font(.caption)
                    .padding(.top, 5)
                    .opacity(viewModel.emailError == nil ? 0 : 1)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.emailError)
                    .frame(height: 3)
            }

            // Password Field
            VStack(alignment: .leading, spacing: 4) {
                FormLabel(title: AuthenticationStrings.RegisterView.password.capitalized)

                SecureField(AuthenticationStrings.RegisterView.passwordField, text: $viewModel.registerRequest.password)
                    .formTextFieldStyle()
                    .textContentType(.password)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .comfirmPassword }
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
                    Text(AuthenticationStrings.RegisterView.mustInclude)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Confirm Password Field
            VStack(alignment: .leading, spacing: 4) {
                FormLabel(title: AuthenticationStrings.RegisterView.confirmPassword)

                SecureField(AuthenticationStrings.RegisterView.confirmPasswordField, text: $viewModel.registerRequest.confirmPassword)
                    .formTextFieldStyle()
                    .textContentType(.password)
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
            Text(AuthenticationStrings.RegisterView.createYourAccount)
                .primaryButtonStyle()
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
        }
        .disabled(!viewModel.isFormValid)
        .opacity(!viewModel.isFormValid ? 0.7 : 1.0)
    }
}

private extension RegisterView {
    var footer: some View {
        VStack {
            Divider()

            Button {
                dismiss()
            } label: {
                HStack {
                    Text(AuthenticationStrings.RegisterView.getAccount)
                    Text(AuthenticationStrings.RegisterView.signIn)
                        .bold()
                }
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
    }
}


#Preview {
    RegisterView(loginService: LoginViewModel())
}

struct FormLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}
