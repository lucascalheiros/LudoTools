//
//  PostTokenResponse.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

import Foundation

struct PostTokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
}
