//
//  LudopediaApi.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

import Foundation

final class LudopediaApi {
    @Inject(URLSessionClient.self)
    private var client: URLSessionClient

    @Inject(URLRequestBuilder.self, .ludopediaRequestBuilder)
    private var urlRequestBuilder: URLRequestBuilder

    private func request<Success: Decodable>(
        _ apiEntry: ApiEntry
    ) async -> Result<Success, NetworkError> {
        return await client.request(urlRequestBuilder.createRequest(apiEntry), as: Success.self)
    }

    func postTokenrequest(
        code: String
    ) async -> Result<PostTokenResponse, NetworkError> {
        return await request(ApiEntry(
            .post,
            "tokenrequest",
            auth: .none,
            query: ["code": code],
            body: PostTokenRequest(code: code)
        ))
    }

    func getGames(
        _ params: GetGamesParams,
        _ pageInfo: PageInfo
    ) async -> Result<GamesResponse, NetworkError> {
        var query: [String: String?] = [:]
        query.merge(params.asDictionary() ?? [:]) { $1 }
        query.merge(pageInfo.asDictionary() ?? [:]) { $1 }
        return await request(ApiEntry(
            .get,
            "api/v1/jogos",
            auth: .bearer,
            query: query
        ))
    }

    func getProfile() async -> Result<UserResponse, NetworkError> {
        return await request(ApiEntry(
            .get,
            "api/v1/me",
            auth: .bearer
        ))
    }

    func getCollection(
        _ params: GetCollectionParams,
        _ pageInfo: PageInfo
    ) async -> Result<GameCollectionResponse, NetworkError> {
        var query: [String: String?] = [:]
        query.merge(params.asDictionary() ?? [:]) { $1 }
        query.merge(pageInfo.asDictionary() ?? [:]) { $1 }
        return await request(ApiEntry(
            .get,
            "api/v1/colecao",
            auth: .bearer,
            query: query
        ))
    }
}

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


extension Encodable {
    func asDictionary() -> [String: String?]? {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = jsonObject as? [String: Any] else { return nil }

            return dict.mapValues { value in
                switch value {
                case let v as String: return v
                case let v as Int: return String(v)
                case let v as Double: return String(v)
                case let v as Float: return String(v)
                case let v as Bool: return v ? "true" : "false"
                case let v as Int8: return String(v)
                case let v as Int16: return String(v)
                case let v as Int32: return String(v)
                case let v as Int64: return String(v)
                case let v as UInt: return String(v)
                case let v as UInt8: return String(v)
                case let v as UInt16: return String(v)
                case let v as UInt32: return String(v)
                case let v as UInt64: return String(v)
                case let v as Date: return ISO8601DateFormatter().string(from: v)
                default:
                    return nil
                }
            }
        } catch {
            Logger.error("❌ Error encoding to dictionary: \(error)")
            return nil
        }
    }
}
