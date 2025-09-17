//
//  LudopediaURLRequestBuilderImp.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 10/08/25.
//

import Foundation

class LudopediaURLRequestBuilderImp: URLRequestBuilder {

    @LudopediaApiConfigWrapper
    private var apiConfig

    @Inject(AuthenticationLocalDataSource.self)
    private var localDataSource

    private func createRequest(_ path: String, _ method: HttpMethod) -> URLRequest {
        let url = URL(string: "\(apiConfig.baseUrl)/\(path)")!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }

    func createRequest(_ apiEntry: ApiEntry) -> URLRequest {
        var request = createRequest(apiEntry.pathWithQuery, apiEntry.method)

        if let body = apiEntry.body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                Logger.error("Failure to encode body: \(error)")
            }
        }

        switch apiEntry.auth {
        case .bearer:
            request.setValue("Bearer \(localDataSource.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        default:
            break
        }

        return request
    }
}
