//
//  ContentView.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

import SwiftUI
import SwiftData
import UIKit

struct ContentView: View {
    @State private var startupState: StartupState = .loading

    @Inject(LoginStateUseCase.self)
    private var loginStateUseCase

    var body: some View {
        ZStack {
            Color.primaryContainer.ignoresSafeArea()

            Group {
                switch startupState {
                case .loading:
                    SplashScreen()
                case .loggedIn:
                    MainScreen()
                        .background(Color.primaryContainer)
                case .loggedOut:
                    LoginScreen()
                }
            }
            .animation(.easeInOut, value: startupState)
            .transition(.opacity)
            .onReceive(loginStateUseCase.execute()) {
                switch $0 {
                case .localLogin, .ludopediaLogin:
                    startupState = .loggedIn
                case .notLoggedIn:
                    startupState = .loggedOut
                }
            }
        }
        .environment(\.colorScheme, .dark)
        .preferredColorScheme(.dark)
        .task { @MainActor in
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.overrideUserInterfaceStyle = .dark
            }
        }
    }
}

fileprivate enum StartupState {
    case loading
    case loggedIn
    case loggedOut
}

#Preview {
    ContentView()
}
