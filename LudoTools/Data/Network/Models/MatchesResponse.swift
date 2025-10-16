//
//  MatchesResponse.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

import SwiftUI

struct MatchesResponse: Codable, PaginatedResponse {
    let content: [MatchModel]
    let total: Int

    enum CodingKeys: String, CodingKey {
        case content = "partidas"
        case total
    }
}

struct MatchModel: Codable, Identifiable {
    let id: Int
    let quantity: Int?
    let isDigital: Int?
    let duration: Int?
    let date: String
    let description: String?
    let game: SimpleGameModel
    let expansions: [SimpleGameModel]
    let players: [MatchPlayer]

    enum CodingKeys: String, CodingKey {
        case id = "id_partida"
        case quantity = "qt_partidas"
        case isDigital = "fl_digital"
        case duration = "duracao"
        case date = "dt_partida"
        case description = "descricao"
        case game = "jogo"
        case expansions = "expansoes"
        case players = "jogadores"
    }
}

struct MatchPlayer: Codable, Identifiable {
    var id: Int {
        playerMatchId
    }
    let playerMatchId: Int
    let name: String
    let userId: Int?
    let isWinner: Int
    let score: Int?
    let observation: String
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case playerMatchId = "id_partida_jogador"
        case name = "nome"
        case userId = "id_usuario"
        case isWinner = "fl_vencedor"
        case score = "vl_pontos"
        case observation = "observacao"
        case thumb = "thumb"
    }
}
