//
//  ApiEntry.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

import Foundation

struct ApiEntry {
    let path: String
    let query: [String: String?]
    let auth: ApiAuth
    let method: HttpMethod
    let body: Encodable?

    var pathWithQuery: String {
        var pathWithQuery = path
        if !query.isEmpty {
            pathWithQuery += "?" + query.compactMap { key, value in
                guard let value else { return nil }
                return "\(key)=\(value)"
            }.joined(separator: "&")
        }
        return pathWithQuery
    }

    init(
        _ method: HttpMethod,
        _ path: String,
        auth: ApiAuth,
        query: [String : String?] = [:],
        body: Encodable? = nil
    ) {
        self.path = path
        self.query = query
        self.auth = auth
        self.method = method
        self.body = body
    }
}

enum ApiAuth {
    case none
    case basic
    case bearer
}
