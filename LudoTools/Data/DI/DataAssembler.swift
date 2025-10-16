//
//  DataAssembler.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 31/08/25.
//

import SwiftData

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
        container.register(
            .singleton,
            MatchesRepository.self,
            MatchesRepository.init
        )
        container.register(
            .singleton,
            LudoUsersRepository.self,
            LudoUsersRepository.init
        )
        container.register(.singleton, ModelContainer.self) { _ in
            let schema = Schema([
                PlayerInfo.self,
                LudoUser.self,
                PlayerScoreEntry.self,
                ScoreLogEntity.self,
                ScoringEntity.self,
                MatchEntity.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }
}
