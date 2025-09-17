//
//  ModuleRegister.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

import SwiftData

struct ModuleRegister {
    @ContainerWrapped
    var container: Container

    func register() {
        DataAssembler.assembly(container)
        DomainAssembler.assembly(container)

        container.register(.singleton, ModelContainer.self, factory: { _ in
            let schema = Schema([
                PlayerInfo.self,
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
        })
    }
}
