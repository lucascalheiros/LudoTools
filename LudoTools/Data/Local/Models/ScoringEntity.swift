//
//  ScoringSheet.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 01/09/25.
//

import Foundation
import SwiftData

@Model
class ScoringEntity {
    @Attribute(.unique) var id: UUID
    var name: String
    var date: Date
    var playerEntriesAdded: Int = 0
    @Relationship(deleteRule: .cascade) var playerScoreEntries: [PlayerScoreEntry] = []
    var scoringType: ScoringType? = ScoringType.morePoints
    var nonNullScoringType: ScoringType {
        scoringType ?? .morePoints
    }
    var sortedPlayerScoreEntries: [(score: Int, players: [PlayerScoreEntry])] {
        let grouped = Dictionary(grouping: playerScoreEntries, by: { $0.score })

        let sortedGroups = grouped.keys.sorted(by: >).map { score in
            (score, grouped[score]!)
        }

        switch nonNullScoringType {
        case .morePoints:
            return sortedGroups
        case .lessPoints:
            return sortedGroups.reversed()
        }
    }

    init(id: UUID = UUID(), name: String = "Unamed", date: Date = Date(), playerEntriesAdded: Int = 0, playerScoreEntries: [PlayerScoreEntry] = [],
         scoringType: ScoringType = .morePoints) {
        self.id = id
        self.name = name
        self.date = date
        self.playerEntriesAdded = playerEntriesAdded
        self.playerScoreEntries = playerScoreEntries
        self.scoringType = scoringType
    }

    func toggleScoringType() {
        scoringType = nonNullScoringType == .lessPoints ? .morePoints : .lessPoints
    }
}
