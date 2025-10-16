//
//  LudoUser.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 15/10/25.
//

import SwiftData

@Model
class LudoUser {
    @Attribute(.unique) var id: Int
    var user: String
    var thumb: String

    init(id: Int, user: String, thumb: String) {
        self.id = id
        self.user = user
        self.thumb = thumb
    }
}
