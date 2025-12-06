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

    init(search: String? = nil, type: GameType = .all, baseGameId: Int? = nil) {
        self.search = search
        self.type = type
        self.baseGameId = baseGameId
    }

    enum CodingKeys: String, CodingKey {
        case search = "search"
        case type = "tp_jogo"
        case baseGameId = "id_jogo_base"
    }
}

struct GetCollectionParams: Codable, Hashable {
    var collectionType: CollectionType
    var search: String?
    var type: GameType
    var sort: CollectionSort?
    var playerCount: Int?

    init(
        collectionType: CollectionType,
        search: String? = nil,
        type: GameType = .all,
        sort: CollectionSort? = nil,
        playerCount: Int? = nil
    ) {
        self.collectionType = collectionType
        self.search = search
        self.type = type
        self.sort = sort
        self.playerCount = playerCount
    }

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

enum CollectionSort: String, Codable {
    case name = "nome"
    case rank
    case rating = "nota"
    case matches
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

struct GetMatchesParams: Codable, Hashable {
    let startDate: DayDate?
    let endDate: DayDate?
    let gameId: String?
    let playerId: Int?
    let guestPlayer: String?
    let weekday: Int?

    enum CodingKeys: String, CodingKey {
        case startDate = "dt_ini"
        case endDate = "dt_fim"
        case gameId = "id_jogo"
        case playerId = "id_usuario_jogador"
        case guestPlayer = "jogador"
        case weekday = "weekday"
    }
}

struct DayDate: Codable, Hashable {
    let year: Int
    let month: Int
    let day: Int

    var isoDate: String {
        return "\(year)-\(month)-\(day)"
    }
}
