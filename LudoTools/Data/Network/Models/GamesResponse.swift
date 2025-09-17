//
//  GamesResponse.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

import SwiftUI

struct GamesResponse: Codable, PaginatedResponse {
    let content: [SimpleGameModel]
    let total: Int

    enum CodingKeys: String, CodingKey {
        case content = "jogos"
        case total
    }
}


struct SimpleGameModel: BasicGameInfo, Codable, Identifiable {
    let id: Int
    let name: String
    let nmOriginal: String
    let thumb: String
    let link: String

    enum CodingKeys: String, CodingKey {
        case id = "id_jogo"
        case name = "nm_jogo"
        case nmOriginal = "nm_original"
        case thumb
        case link
    }
}
