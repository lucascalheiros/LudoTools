struct CompleteGameModel: LudopediaGame, Identifiable, Codable {
    let id: Int
    let name: String
    let thumb: String
    let type: String
    let link: String
    let yearPublished: Int
    let yearNational: Int?
    let minPlayers: Int
    let maxPlayers: Int
    let playTime: Int?
    let minAge: Int?
    let ownedCount: Int?
    let hadCount: Int?
    let favoriteCount: Int?
    let wantedCount: Int?
    let playedCount: Int?
    let mechanics: [Mechanic]
    let categories: [Category]
    let themes: [Theme]
    let artists: [Professional]
    let designers: [Professional]

    func toGameInfo() -> GameInfo {
        GameInfo(id: id, name: name, thumb: thumb, link: link)
    }

    enum CodingKeys: String, CodingKey {
        case id = "id_jogo"
        case name = "nm_jogo"
        case thumb
        case type = "tp_jogo"
        case link
        case yearPublished = "ano_publicacao"
        case yearNational = "ano_nacional"
        case minPlayers = "qt_jogadores_min"
        case maxPlayers = "qt_jogadores_max"
        case playTime = "vl_tempo_jogo"
        case minAge = "idade_minima"
        case ownedCount = "qt_tem"
        case hadCount = "qt_teve"
        case favoriteCount = "qt_favorito"
        case wantedCount = "qt_quer"
        case playedCount = "qt_jogou"

        case mechanics = "mecanicas"
        case categories = "categorias"
        case themes = "temas"
        case artists = "artistas"
        case designers = "designers"
    }
}

extension CompleteGameModel {
    struct Mechanic: Codable, Hashable {
        let id: Int
        let name: String

        enum CodingKeys: String, CodingKey {
            case id = "id_mecanica"
            case name = "nm_mecanica"
        }
    }

    struct Category: Codable, Hashable {
        let id: Int
        let name: String

        enum CodingKeys: String, CodingKey {
            case id = "id_categoria"
            case name = "nm_categoria"
        }
    }

    struct Theme: Codable, Hashable {
        let id: Int
        let name: String

        enum CodingKeys: String, CodingKey {
            case id = "id_tema"
            case name = "nm_tema"
        }
    }

    struct Professional: Codable, Hashable {
        let id: Int
        let name: String

        enum CodingKeys: String, CodingKey {
            case id = "id_profissional"
            case name = "nm_profissional"
        }
    }
}
