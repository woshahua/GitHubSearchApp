//
//  HTTPClient.swift
//  GitHubSearchApp
//
//  Created by Hang Gao on 2021/12/16.
//

import Foundation
import Combine

struct HTTPClient {
    let session = URLSession(configuration: .default)

    func send<T1: Request, T2: Codable>(_ request: T1, completion: @escaping (Result<T2, APIError>) -> Void) {
        guard let req = request.buildRequest() else { return }
        let task = session.dataTask(with: req) { data, res, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(.normal(error)))
                    return
                }
                completion(.failure(.unknown))
                return
            }

            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(T2.self, from: data)
                completion(.success(value))
            } catch {
                completion(.failure(.normal(error)))
            }
        }
        task.resume()
    }
}

enum APIError: Error {
    case normal(Error)
    case unknown
}
