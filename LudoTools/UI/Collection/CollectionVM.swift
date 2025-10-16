//
//  CollectionVM.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 08/09/25.
//

import Combine
import SwiftUI

@MainActor
class CollectionVM: ObservableObject {
    @Published var playerCount = 0 {
        didSet {
            updateGameCollectionSliceParams()
        }
    }
    @Published var gameType = GameType.all {
        didSet {
            updateGameCollectionSliceParams()
        }
    }
    @Published var isLoadingMoreGames = false
    @Published var userGames: [GameCollectionModel] = []
    private var cancellable = Set<AnyCancellable>()
    private let getGameCollectionSlice: GetGameCollectionSlice

    init() {
        @ContainerWrapped
        var container: Container
        let scope = container.newScope()
        // This slice instance can be reused in another slice that uses this scope
        getGameCollectionSlice = scope.resolve(GetGameCollectionSlice.self)
        observeGameCollectionSlice()
        updateGameCollectionSliceParams()
    }

    func loadMoreGames() {
        Task {
            await getGameCollectionSlice.loadMoreGames()
        }
    }

    func updateGameCollectionSliceParams() {
        getGameCollectionSlice.params = .init(
            collectionType: .collection,
            search: nil,
            type: gameType,
            sort: nil,
            playerCount: playerCount == 0 ? nil : playerCount
        )
    }

    func observeGameCollectionSlice() {
        getGameCollectionSlice.gameCollection
            .sink { [weak self] in
                self?.userGames = $0
            }
            .store(in: &cancellable)
        getGameCollectionSlice.$isLoadingMoreGames
            .sink { [weak self] in
                self?.isLoadingMoreGames = $0
            }
            .store(in: &cancellable)
    }

}
