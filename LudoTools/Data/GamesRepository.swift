//
//  GamesRepository.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 08/09/25.
//

import Combine

class GamesRepository {

    private let requestable = {
        @Inject(LudopediaApi.self)
        var ludopediaApi: LudopediaApi
        return PaginatedRequestable(request: ludopediaApi.getGames)
    }()


    func gamesPublisher(_ params: GetGamesParams) -> AnyPublisher<[SimpleGameModel], Never> {
        return requestable.dataPublisher(params)
    }

    func loadMoreGames(_ params: GetGamesParams) async -> Result<Bool, Never> {
        await requestable.loadMore(params)
    }
}
