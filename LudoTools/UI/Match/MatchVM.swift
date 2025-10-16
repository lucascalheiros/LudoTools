//
//  MatchVM.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

import SwiftUI
import Combine

@MainActor
class MatchVM: ObservableObject {
    @Published var game: (GameInfo)?
    @Published var expansions: [GameInfo] = []
    @Published var players: [PlayerInfo] = []
    @Published var startDate = Date()
    @Published var finishedDate = Date()
    @Published var isMatchFinished = false
    @Published var sheetState: SheetState? = nil
    @Published var showGameExpansionPicker = false
    @Published var showExpansions = true
    @Published var showPlayers = true
    var isSaveDisabled: Bool {
        game == nil
    }

    var cancellable = Set<AnyCancellable>()

    init() {
        startObserving()
    }

    func startObserving() {
        observeCleanupExpansionsOnGameChange()
    }

    func stopObserving() {
        cancellable.removeAll()
    }

    func showGamePicker() {
        sheetState = .gamePicker
    }

    func showPlayerPicker() {
        sheetState = .playerPicker
    }

    func showExpansionPicker() {
        if let game {
            sheetState = .expansionPicker(gameId: game.id)
        }
    }

    func removeExpansion(_ expansion: GameInfo) {
        expansions.removeAll(where: {
            $0.id == expansion.id
        })
    }

    func removePlayer(_ expansion: PlayerInfo) {
        players.removeAll(where: {
            $0.name == expansion.name
        })
    }

    private func observeCleanupExpansionsOnGameChange() {
        $game.removeDuplicates(by: {
            $0?.id == $1?.id
        }).sink { [weak self] _ in
            self?.showExpansions = true
            self?.expansions = []
        }
        .store(in: &cancellable)
    }

    enum SheetState: Identifiable {
        var id: String {
            switch self {
                case .gamePicker: "gamePicker"
                case .expansionPicker(let gameId): "expansionPicker(\(gameId))"
                case .playerPicker: "playerPicker"
            }
        }

        case gamePicker
        case expansionPicker(gameId: Int)
        case playerPicker
    }
}
