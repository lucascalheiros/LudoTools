//
//  PlayerScoreEntry.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 31/08/25.
//

import SwiftData

@Model
class PlayerScoreEntry {
    var type: PlayerType
    var playerName: String // for guest
    var playerInfo: PlayerInfo? // for registered
    var score: Int = 0
    var scoreLogs: [ScoreLogEntity]

    init(type: PlayerType, playerName: String = "", playerInfo: PlayerInfo? = nil, score: Int = 0, scoreLogs: [ScoreLogEntity] = []) {
        self.type = type
        self.playerName = playerName
        self.playerInfo = playerInfo
        self.score = score
        self.scoreLogs = scoreLogs
    }

    var displayName: String {
        switch type {
        case .guest:
            return playerName
        case .registered:
            return playerInfo?.name ?? "Unknown"
        }
    }
}
