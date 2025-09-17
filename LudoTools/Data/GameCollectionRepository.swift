//
//  GameCollectionRepository.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 08/09/25.
//

import Combine

class GameCollectionRepository {

    private let requestable = {
        @Inject(LudopediaApi.self)
        var ludopediaApi: LudopediaApi
        return PaginatedRequestable(request: ludopediaApi.getCollection)
    }()


    func gamesPublisher(_ params: GetCollectionParams) -> AnyPublisher<[GameCollectionModel], Never> {
        requestable.dataPublisher(params)
    }

    func loadMoreGames(_ params: GetCollectionParams) async -> Result<Bool, Never> {
        await requestable.loadMore(params)
    }
}
