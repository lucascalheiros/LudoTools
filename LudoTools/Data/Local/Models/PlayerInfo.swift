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
    var ludoUser: LudoUser?

    init(name: String, ludoUser: LudoUser?) {
        self.name = name
        self.ludoUser = ludoUser
    }
}
