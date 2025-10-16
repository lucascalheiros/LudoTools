//
//  MatchesRepository.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

import Combine

class MatchesRepository {
    private let requestable = {
        @Inject(LudopediaApi.self)
        var ludopediaApi: LudopediaApi
        return PaginatedRequestable(request: ludopediaApi.getMatches)
    }()

    func matches(_ params: GetMatchesParams) -> AnyPublisher<[MatchModel], Never> {
        requestable.dataPublisher(params)
    }

    func loadMore(_ params: GetMatchesParams) async -> Result<Bool, Never> {
        await requestable.loadMore(params)
    }
}
