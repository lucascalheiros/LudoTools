//
//  LudopediaApi+Params.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/10/25.
//

struct GetGamesParams: Codable, Hashable {
    let search: String?
    let type: GameType
    let baseGameId: Int?

    enum CodingKeys: String, CodingKey {
        case search = "search"
        case type = "tp_jogo"
        case baseGameId = "id_jogo_base"
    }
}

struct GetCollectionParams: Codable, Hashable {
    let collectionType: CollectionType
    let search: String?
    let type: GameType
    let sort: String?
    let playerCount: Int?

    enum CodingKeys: String, CodingKey {
        case collectionType = "lista"
        case search = "search"
        case type = "tp_jogo"
        case sort = "ordem"
        case playerCount = "qt_jogadores"
    }
}

struct PageInfo: Codable {
    let page: Int
    let perPage: Int = 20

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case perPage = "rows"
    }
}

enum GameType: String, Codable {
    case all = ""
    case base = "b"
    case expansion = "e"
}

enum CollectionType: String, Codable {
    case collection = "colecao"
    case favorites = "favoritos"
    case had = "teve"
    case wish = "lista_desejos"
    case commented = "comentados"
    case graded = "notas"
    case played = "jogados"
}
