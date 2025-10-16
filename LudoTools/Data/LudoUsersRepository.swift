//
//  LudoUsersRepository.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 18/09/25.
//

import Combine

class LudoUsersRepository {

    private let requestable = {
        @Inject(LudopediaApi.self)
        var ludopediaApi: LudopediaApi
        return PaginatedRequestable(request: ludopediaApi.getUsers)
    }()


    func publisher(_ params: String) -> AnyPublisher<[UserModel], Never> {
        return requestable.dataPublisher(params)
    }

    func loadMore(_ params: String) async {
        await requestable.loadMore(params)
    }
}
