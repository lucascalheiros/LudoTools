//
//  GetGamesSlice.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

import Combine
import SwiftUI

class GetGamesSlice {

    @Published var query: GameQueryOptions?
    var games: AnyPublisher<[GameInfo], Never> {
        $query
            .flatMap { [weak self] query in
                guard let self, let query else { return Empty<[GameInfo], Never>().eraseToAnyPublisher() }
                switch query {

                case .allGames:
                    return getGamesSlice.games
                        .map { $0.map { $0.toGameInfo() } }
                        .eraseToAnyPublisher()

                case .collection:
                    return getGameCollectionSlice.gameCollection
                        .map { $0.map { $0.toGameInfo() } }
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    var isLoading: AnyPublisher<Bool, Never> {
        getGamesSlice.$isLoadingMoreGames
            .combineLatest(getGameCollectionSlice.$isLoadingMoreGames)
            .map { $0 || $1 }
            .eraseToAnyPublisher()
    }
    private let getGamesSlice: GetGamesFromAllSlice
    private let getGameCollectionSlice: GetGameCollectionSlice
    var cancellable = Set<AnyCancellable>()

    init(scopedResolver: Resolver) {
        getGamesSlice = scopedResolver.resolve(GetGamesFromAllSlice.self)
        getGameCollectionSlice = scopedResolver.resolve(GetGameCollectionSlice.self)
        $query
            .compactMap { $0 }
            .sink { [weak self] query in
                switch query {

                case .allGames(let params):
                    self?.getGamesSlice.params = params

                case .collection(let params):
                    self?.getGameCollectionSlice.params = params
                }
            }
            .store(in: &cancellable)
    }

    func loadMoreGames() async {
        switch query {

        case .allGames:
            await getGamesSlice.loadMoreGames()

        case .collection:
            await getGameCollectionSlice.loadMoreGames()

        case .none:
            break
        }
    }

    enum GameQueryOptions: Hashable {
        case collection(GetCollectionParams)
        case allGames(GetGamesParams)
    }
}
