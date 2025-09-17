//
//  DomainAssembler.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 31/08/25.
//

struct DomainAssembler: Assembler {
    static func assembly(_ container: Container) {
        container.register(
            .weakSingleton,
            LoginStateUseCase.self,
            LoginStateUseCase.init
        )
        container.register(
            .weakSingleton,
            LoginUseCase.self,
            LoginUseCase.init
        )
    }
}
