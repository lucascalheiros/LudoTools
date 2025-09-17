//
//  LoginScreen.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 27/08/25.
//

import SwiftUI

struct LoginScreen: View {
    private var oauthHandler = LudopediaOauthHandler()

    @Inject(LudopediaApi.self)
    var api: LudopediaApi

    var body: some View {
        NavigationView {
            VStack {
                Text("O LudoTools é construído através da API do Ludopedia.")
                    .multilineTextAlignment(.center)
                    .padding()

                Button(action: requestOauth) {
                    Text("Acessar com Ludopedia")
                }
                .buttonStyle(.borderedProminent)
                .padding()

                Button(action: {

                }) {
                    Text("Acesso local")
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Bem-vindo")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onOpenURL { incomingURL in
            print("App was opened via URL: \(incomingURL)")
            Task {
                await oauthHandler.handleOauthRedirectWithLogin(url: incomingURL)
            }
        }
    }


    private func requestOauth() {
        Task {
            await oauthHandler.requestOauth()
        }
    }
}
