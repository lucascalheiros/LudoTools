//
//  UserResponse.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

struct UserResponse: Codable, PaginatedResponse {
    let content: [UserModel]
    let total: Int

    enum CodingKeys: String, CodingKey {
        case content = "usuarios"
        case total
    }
}

struct UserModel: Identifiable, Codable {
    let id: Int
    let user: String
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case id = "id_usuario"
        case user = "usuario"
        case thumb
    }
}
