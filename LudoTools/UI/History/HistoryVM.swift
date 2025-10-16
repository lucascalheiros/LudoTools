//
//  HistoryVM.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

import Combine
import SwiftUI

class HistoryVM: ObservableObject {

    @Inject(MatchesRepository.self)
    private var matchesRepository: MatchesRepository

    @Published var matches: [MatchModel] = []
    @Published var params = GetMatchesParams(startDate: nil, endDate: nil, gameId: nil, playerId: nil, guestPlayer: nil, weekday: nil)

    var cancellable = Set<AnyCancellable>()

    init() {
        $params.flatMap { [weak self] in
            guard let self else { return Empty<[MatchModel], Never>().eraseToAnyPublisher() }

            return self.matchesRepository.matches($0).eraseToAnyPublisher()
        }.receive(on: RunLoop.main)
            .sink {  [weak self] in
                self?.matches = $0
            }.store(in: &cancellable)
        loadMore()
    }

    func loadMore() {
        Task {
            let _ = await matchesRepository.loadMore(params)
        }
    }

}
