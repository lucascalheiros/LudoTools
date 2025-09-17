//
//  ScoringLog.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 31/08/25.
//

import SwiftData
import Foundation

@Model
class ScoreLogEntity {
    var date: Date
    var points: Int
    var playerScoreEntry: PlayerScoreEntry

    init(date: Date, points: Int, playerScoreEntry: PlayerScoreEntry) {
        self.date = date
        self.points = points
        self.playerScoreEntry = playerScoreEntry
    }
}

