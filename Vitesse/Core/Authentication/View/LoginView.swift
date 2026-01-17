//
//  LoginView.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                logo
                form
                actions
                Spacer()
                footer
            }
        }
        .onChange(of: viewModel.isAuthenticated) { oldValue, newValue in
            if newValue {
                focusedField = nil
            }
        }
    }
}

private extension LoginView {
    var logo: some View {
        Image(.vitesseLogo)
            .resizable()
            .scaledToFill()
            .frame(width: 220, height: 220)
            .accessibilityLabel(AuthenticationStrings.LoginView.accessibilityLabelLogo)
    }
}

private extension LoginView {
    var form: some View {
        VStack(spacing: 10) {
            emailField
            passwordField
            errorMessage
            forgotPasswordButton
        }
    }
}

private extension LoginView {
    var emailField: some View {
        TextField(AuthenticationStrings.LoginView.emailField, text: $viewModel.email)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textFieldModifier()
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .focused($focusedField, equals: .email)
            .submitLabel(.next)
            .onSubmit { focusedField = .password }
    }
}

private extension LoginView {
    var passwordField: some View {
        SecureField(AuthenticationStrings.LoginView.passwordField, text: $viewModel.password)
            .textFieldModifier()
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($focusedField, equals: .password)
            .submitLabel(.go)
            .onSubmit { viewModel.loginIfPossible() }
    }
}

private extension LoginView {
    var errorMessage: some View {
        Text(viewModel.errorMessage ?? " ")
            .foregroundStyle(.red)
            .font(.callout)
            .padding(.top, -1)
            .opacity(viewModel.errorMessage == nil ? 0 : 1)
            .animation(.easeInOut(duration: 0.2), value: viewModel.errorMessage)
            .frame(minHeight: 20)
    }
}

private extension LoginView {
    var forgotPasswordButton: some View {
        Button {
            print("DEBUG: Show forgot password")
        } label: {
            Text(AuthenticationStrings.LoginView.forgotPassword)
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.top, -3)
                .padding(.trailing, 28)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

private extension LoginView {
    var actions: some View {
        VStack(spacing: 16) {
            loginButton
            CustomSeparatorView()
            createAccountButton
        }
    }
}

private extension LoginView {
    var loginButton: some View {
        Button {
            viewModel.loginIfPossible()
        } label: {
            Text(AuthenticationStrings.LoginView.connexionButton)
                .primaryButtonStyle()
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
        }
        .disabled(!viewModel.formIsValid)
        .opacity(viewModel.formIsValid ? 1 : 0.7)
        .padding(.top, 10)
    }
}

private extension LoginView {
    var createAccountButton: some View {
        NavigationLink {
            RegisterView(loginService: viewModel)
                .navigationBarBackButtonHidden()
        } label: {
            Text(AuthenticationStrings.LoginView.createAccount)
                .primaryButtonStyle()
        }
    }
}

private extension LoginView {
    var footer: some View {
        VStack {
            Divider()
            
            NavigationLink {
                RegisterView(loginService: viewModel)
                    .navigationBarBackButtonHidden()
            } label: {
                HStack {
                    Text(AuthenticationStrings.LoginView.noAccount)
                    Text(AuthenticationStrings.LoginView.signUp)
                        .bold()
                }
                .font(.footnote)
            }
            .padding(.vertical, 16)
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

