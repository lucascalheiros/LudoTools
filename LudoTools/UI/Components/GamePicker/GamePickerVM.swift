//
//  GamePickerVM.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 16/09/25.
//

import Combine
import SwiftUI

@MainActor
class GamePickerVM: ObservableObject {

    @Inject(GamesRepository.self)
    private var gamesRepository: GamesRepository

    @Inject(GameCollectionRepository.self)
    private var gameCollectionRepository: GameCollectionRepository

    private var cancellable: Set<AnyCancellable> = []

    @Published private var searchQuery: GameQueryOptions?

    @Published private(set) var games: [BasicGameInfo] = []

    @Published private(set) var isLoadingMoreGames: Bool = false


    init() {
        $searchQuery
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.loadMoreGames()
            }
            .store(in: &cancellable)

        $searchQuery
            .flatMap { [weak self] query in
                guard let self, let query else { return Empty<[BasicGameInfo], Never>().eraseToAnyPublisher() }
                switch query {

                case .allGames(let params):
                    return gamesRepository.gamesPublisher(params)
                        .map { $0.map { $0 as any BasicGameInfo } }
                        .eraseToAnyPublisher()

                case .collection(let params):
                    return gameCollectionRepository.gamesPublisher(params)
                        .map { $0.map { $0 as any BasicGameInfo } }
                        .eraseToAnyPublisher()
                }
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] games in
                Logger.debug("Games count on VM: \(games.count)")
                self?.games = games
            }
            .store(in: &cancellable)
    }

    func loadMoreGames() {
        Task {
            isLoadingMoreGames = true
            switch searchQuery {

            case .allGames(let params):
                let _ = await gamesRepository.loadMoreGames(params)


            case .collection(let params):
                let _ = await gameCollectionRepository.loadMoreGames(params)

            case .none:
                break
            }
            isLoadingMoreGames = false
        }
    }

    func updateQuery(_ query: GameQueryOptions) {
        searchQuery = query
    }
}
