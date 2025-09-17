//
//  DataAssembler.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 31/08/25.
//

struct DataAssembler: Assembler {
    static func assembly(_ container: Container) {
        container.register(
            .singleton,
            URLRequestBuilder.self,
            .ludopediaRequestBuilder,
            LudopediaURLRequestBuilderImp.init
        )
        container.register(
            .singleton,
            URLSessionClient.self,
            URLSessionClient.init
        )
        container.register(
            .singleton,
            LudopediaApi.self,
            LudopediaApi.init
        )
        container.register(
            .singleton,
            AuthenticationLocalDataSource.self,
            AuthenticationLocalDataSource.init
        )
        container.register(
            .singleton,
            AuthenticationRepository.self,
            AuthenticationRepository.init
        )
        container.register(
            .singleton,
            GamesRepository.self,
            GamesRepository.init
        )
        container.register(
            .singleton,
            GameCollectionRepository.self,
            GameCollectionRepository.init
        )
    }
}
