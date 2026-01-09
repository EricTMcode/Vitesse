//
//  VitesseApp.swift
//  Vitesse
//
//  Created by Eric on 09/01/2026.
//

import SwiftUI

@main
struct VitesseApp: App {
    @StateObject var viewModel = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: viewModel)
        }
    }
}
