//
//  PlayerInfo.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 31/08/25.
//

import SwiftData

@Model
class PlayerInfo {
    var name: String
    var ludopediaId: String

    init(name: String, ludopediaId: String) {
        self.name = name
        self.ludopediaId = ludopediaId
    }
}
