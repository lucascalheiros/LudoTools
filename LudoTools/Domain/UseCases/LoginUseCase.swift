//
//  LoginUseCase.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

class LoginUseCase {
    enum LoginOption {
        case local
        case ludopediaOauth(code: String)
    }

    @Inject(AuthenticationRepository.self)
    private var authenticationRepository: AuthenticationRepository

    @ContainerWrapped
    var container: Container

    lazy var scope: Container.Scope = container.newScope()

    var authenticated: AuthenticationRepository {
        scope.resolve(AuthenticationRepository.self)
    }

    func execute(_ option: LoginOption) async -> Bool {
        switch option {
        case .local:
            authenticationRepository.localLogin()

        case .ludopediaOauth(code: let code):
            await authenticationRepository.login(ludopediaOauthCode: code)
        }
    }
}


protocol ScopedDependency {
    init(scope: Resolver)
}
