//
//  AuthenticationLocalDataSource.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 31/08/25.
//

class AuthenticationLocalDataSource {
    @UserDefault(key: "LOCAL_LOGIN_ACTIVE", defaultValue: false)
    var isLocalLogin: Bool?

    @Keychain(key: "LUDOPEDIA_API_ACCESS_TOKEN")
    var accessToken: String?
}
