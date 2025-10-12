//
//  GameCollectionResponse.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 04/09/25.
//

import Foundation

struct GameCollectionResponse: Codable, PaginatedResponse{
    let content: [GameCollectionModel]
    let qtBase: Int
    let qtExp: Int
    let total: Int

    enum CodingKeys: String, CodingKey {
        case content = "colecao"
        case qtBase = "qt_base"
        case qtExp = "qt_exp"
        case total
    }
}

struct GameCollectionModel: BasicGameInfo, Codable, Identifiable {
    let idUsuarioJogo: Int?
    let id: Int
    let name: String
    let thumb: String
    let link: String
    let idUsuario: Int?
    let flTem: Int?
    let flQuer: Int?
    let flTeve: Int?
    let flJogou: Int?
    let comentario: String?
    let comentarioPrivado: String?
    let vlNota: Double?
    let qtPartidas: Int?
    let vlCusto: Double?
    let tags: [Tag]

    enum CodingKeys: String, CodingKey {
        case idUsuarioJogo = "id_usuario_jogo"
        case id = "id_jogo"
        case name = "nm_jogo"
        case thumb
        case link
        case idUsuario = "id_usuario"
        case flTem = "fl_tem"
        case flQuer = "fl_quer"
        case flTeve = "fl_teve"
        case flJogou = "fl_jogou"
        case comentario
        case comentarioPrivado = "comentario_privado"
        case vlNota = "vl_nota"
        case qtPartidas = "qt_partidas"
        case vlCusto = "vl_custo"
        case tags
    }

    struct Tag: Codable, Identifiable, Hashable {
        let id: Int
        let nmTag: String

        enum CodingKeys: String, CodingKey {
            case id = "id_usuario_tag"
            case nmTag = "nm_tag"
        }
    }
}
