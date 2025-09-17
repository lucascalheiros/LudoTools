//
//  MatchEntity.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 01/09/25.
//

import Foundation
import SwiftData

@Model
class MatchEntity {
    @Attribute(.unique) var id: UUID
    var name: String
    var date: Date
    @Relationship(deleteRule: .cascade) var playerScoreEntry: [PlayerScoreEntry] = []

    init(id: UUID, name: String, date: Date, playerScoreEntry: [PlayerScoreEntry]) {
        self.id = id
        self.name = name
        self.date = date
        self.playerScoreEntry = playerScoreEntry
    }
}
