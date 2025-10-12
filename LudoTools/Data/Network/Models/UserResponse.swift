//
//  UserResponse.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

struct UserResponse: Identifiable, Codable {
    let id: Int
    let user: String
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case id = "id_usuario"
        case user = "usuario"
        case thumb
    }
}
