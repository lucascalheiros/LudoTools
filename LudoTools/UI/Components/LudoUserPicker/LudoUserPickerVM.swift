//
//  LudoUserPickerVM.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 18/09/25.
//

import Combine
import SwiftUI

@MainActor
class LudoUserPickerVM: ObservableObject {

    @Inject(LudoUsersRepository.self)
    private var ludoUsersRepository: LudoUsersRepository

    private var cancellable: Set<AnyCancellable> = []

    @Published private var searchQuery: String?

    @Published private(set) var users: [UserModel] = []

    @Published private(set) var isLoadingMoreGames: Bool = false

    init() {
        observeSearchInputUpdates()
        observeRepositoryUpdates()
    }

    func loadMoreGames() {
        Task {
            isLoadingMoreGames = true
            if let searchQuery {
                await ludoUsersRepository.loadMore(searchQuery)
            }
            isLoadingMoreGames = false
        }
    }

    func updateQuery(_ query: String) {
        searchQuery = query
    }

    private func observeRepositoryUpdates() {
        $searchQuery
            .flatMap { [weak self] query in
                guard let self, let query else { return Empty<[UserModel], Never>().eraseToAnyPublisher() }

                return ludoUsersRepository.publisher(query)
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellable)
    }

    private func observeSearchInputUpdates() {
        $searchQuery
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.loadMoreGames()
            }
            .store(in: &cancellable)
    }
}
