//
//  LoginStateUseCase.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

import Combine

class LoginStateUseCase {
    enum LoginState {
        case localLogin
        case ludopediaLogin
        case notLoggedIn
    }

    @Inject(AuthenticationRepository.self)
    private var authenticationRepository: AuthenticationRepository

    func execute() -> AnyPublisher<LoginState, Never> {
        authenticationRepository.loginStatePublisher.eraseToAnyPublisher()
    }
}


