//
//  LudopediaGame.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/09/25.
//

protocol LudopediaGame: Hashable {
    func toGameInfo() -> GameInfo
}


struct GameInfo: Hashable {
    var id: Int
    var name: String
    var thumb: String
    var link: String
}
