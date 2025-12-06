//
//  AuthenticationRepository.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

import Combine

class AuthenticationRepository {
    @Inject(LudopediaApi.self)
    private var api: LudopediaApi

    @Inject(AuthenticationLocalDataSource.self)
    private var localDataSource: AuthenticationLocalDataSource

    private lazy var loginStateSubject = CurrentValueSubject<LoginStateUseCase.LoginState, Never>(loginState)

    var loginStatePublisher: any Publisher<LoginStateUseCase.LoginState, Never> {
        loginStateSubject
    }

    var loginState: LoginStateUseCase.LoginState {
        localDataSource.accessToken != nil ? .ludopediaLogin : (localDataSource.isLocalLogin == true ? .localLogin : .notLoggedIn)
    }

    func login(ludopediaOauthCode code: String) async -> Bool {
        let result = await api.postTokenrequest(code: code)
        if  case .success(let data) = result {
            localDataSource.accessToken = data.accessToken
            return true
        } else {
            return false
        }
    }

    func localLogin() -> Bool {
        return true
    }

    func logout() {
        localDataSource.accessToken = nil
        loginStateSubject.value = .notLoggedIn
    }
}
