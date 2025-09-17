//
//  UserResponse.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

struct UserResponse: Codable {
    let idUsuario: Int
    let usuario: String
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case idUsuario = "id_usuario"
        case usuario
        case thumb
    }
}
