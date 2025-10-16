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

    private var cancellable: Set<AnyCancellable> = []

    @Published private(set) var games: [GameInfo] = []

    @Published private(set) var isLoadingMoreGames: Bool = false

    @Published var selectionState: [AnyHashableKey: (Bool, GameInfo)] = [:]

    private let getGamesSlice: GetGamesSlice

    init() {
        @ContainerWrapped
        var container
        let scope = container.newScope()
        getGamesSlice = scope.resolve(GetGamesSlice.self)
        observeRepositoryUpdates()
        observeLoading()
    }

    func loadMoreGames() {
        Task {
            await getGamesSlice.loadMoreGames()
        }
    }

    func updateQuery(_ query: GetGamesSlice.GameQueryOptions) {
        getGamesSlice.query = query
    }

    private func observeLoading() {
        getGamesSlice.isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self]  in
                self?.isLoadingMoreGames = $0
            }
            .store(in: &cancellable)
    }

    private func observeRepositoryUpdates() {
        getGamesSlice.games
            .receive(on: RunLoop.main)
            .sink { [weak self] games in
                Logger.debug("Games count on VM: \(games.count)")
                self?.games = games
            }
            .store(in: &cancellable)
    }

}
