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

    func getUsers(
        _ search: String,
        _ pageInfo: PageInfo
    ) async -> Result<UserResponse, NetworkError> {
        var query: [String: String?] = ["search":search]
        query.merge(pageInfo.asDictionary() ?? [:]) { $1 }
        return await request(ApiEntry(
            .get,
            "api/v1/usuarios",
            auth: .bearer,
            query: query
        ))
    }

    func getMatches(
        _ params: GetMatchesParams,
        _ pageInfo: PageInfo
    ) async -> Result<MatchesResponse, NetworkError> {
        var query: [String: String?] = [:]
        query.merge(params.asDictionary() ?? [:]) { $1 }
        query.merge(pageInfo.asDictionary() ?? [:]) { $1 }
        return await request(ApiEntry(
            .get,
            "api/v1/partidas",
            auth: .bearer,
            query: query
        ))
    }
}
