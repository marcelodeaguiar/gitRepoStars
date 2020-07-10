//
//  ApiClient.swift
//  gitRepoStars
//
//  Created by Marcelo de Aguiar on 09/07/20.
//  Copyright © 2020 Marcelo de Aguiar. All rights reserved.
//

import Foundation

protocol HttpClientProtocol {
    func get<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, ApiError>) -> Void)
}

struct HttpClient: HttpClientProtocol {
    let session: URLSessionProtocol

    func get<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, ApiError>) -> Void) {
        session.fetch(request: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.unknow(error.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknow("Could not parse response as HTTPURLResponse")))
                return
            }

            if let httpError = HttpClient.parseHttpCodeToApiError(httpResponse.statusCode) {
                completion(.failure(httpError))
                return
            }

            guard let data = data else {
                completion(.failure(.serialization("Empty response data")))
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch let error {
                completion(.failure(.serialization(error.localizedDescription)))
            }
        }.resume()
    }

    private static func parseHttpCodeToApiError(_ code: Int) -> ApiError? {
        switch code {
        case 200..<300:
            return nil

        case 400:
            return .badRequest

        case 401:
            return .unauthorized

        default:
            return .unknow("Request responded with code \(code)")
        }
    }
}
