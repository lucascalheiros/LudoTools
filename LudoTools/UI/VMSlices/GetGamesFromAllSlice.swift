//
//  GetGamesFromAllSlice.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

import Combine
import SwiftUI

class GetGamesFromAllSlice {
    private let gamesRepository: GamesRepository

    @Published var params: GetGamesParams?

    @Published var isLoadingMoreGames = false

    var games: AnyPublisher<[SimpleGameModel], Never> {
        $params
        .flatMap { [weak self] params in
            guard let self, let params else { return Empty<[SimpleGameModel], Never>().eraseToAnyPublisher() }
            return self.gamesRepository.gamesPublisher(params)
        }.eraseToAnyPublisher()
    }

    var cancellable = Set<AnyCancellable>()

    /// Just as an example of usage, this scoped resolver will create and reuse instances that are declared as .scoped or .weakScoped
    init(scopedResolver: Resolver) {
        gamesRepository = scopedResolver.resolve(GamesRepository.self)
        $params
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { $0 }
            .sink { [weak self] _ in
                Task {
                    await self?.loadMoreGames()
                }
            }
            .store(in: &cancellable)
    }

    func loadMoreGames() async {
        guard let params else { return }
        isLoadingMoreGames = true
        let _ = await gamesRepository.loadMoreGames(params)
        isLoadingMoreGames = false
    }
}
