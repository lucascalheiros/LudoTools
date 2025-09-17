//
//  LudopediaOauthHandler.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

import UIKit

class LudopediaOauthHandler {

    @LudopediaApiConfigWrapper
    private var apiConfig

    private var redirectUri: String { "ludotools://oauth" }

    @Inject(LoginUseCase.self)
    private var loginUseCase: LoginUseCase

    @MainActor
    func requestOauth() async -> Bool {
        await UIApplication.shared.open(URL(string: "\(apiConfig.baseUrl)/oauth?app_id=\(apiConfig.appId)&redirect_uri=\(redirectUri)")!)
    }

    func handleOauthRedirectWithLogin(url: URL) async -> Bool {
        guard url.absoluteString.hasPrefix(redirectUri) else { return false }
        let code = url.absoluteString.split(separator: "code=").last?.split(separator: "&").first ?? ""
        return await loginUseCase.execute(.ludopediaOauth(code: String(code)))
    }
}
