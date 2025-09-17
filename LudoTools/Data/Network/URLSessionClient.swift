//
//  URLSessionClient.swift
//  LudoTools
//
//  Created by Lucas Calheiros on 12/08/25.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

final class URLSessionClient {
    func request<Success: Decodable>(_ request: URLRequest, as type: Success.Type) async -> Result<Success, NetworkError> {
        Logger.debug("➡️ Request: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "Unknown URL")")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            Logger.debug("Headers: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            Logger.debug("Body: \(bodyString)")
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                Logger.info("Status: \(httpResponse.statusCode) (\(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)))")
                Logger.debug("Response Headers: \(httpResponse.allHeaderFields)")
            }
            Logger.debug("Response Size: \(data.count) bytes")
            if let string = String(data: data, encoding: .utf8) {
                Logger.debug("Response Body: \(string)")
            } else {
                Logger.debug("Failed to convert Data to String")
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                Logger.error("Invalid HTTP Response")
                return .failure(.invalidResponse)
            }

            do {
                let decoded = try JSONDecoder().decode(Success.self, from: data)
                Logger.info("Decoding successful: \(Success.self)")
                return .success(decoded)
            } catch {
                Logger.error("Decoding failed: \(error.localizedDescription)")
                return .failure(.decodingFailed(error))
            }
        } catch {
            Logger.error("Request failed: \(error.localizedDescription)")
            return .failure(.requestFailed(error))
        }
    }
}
