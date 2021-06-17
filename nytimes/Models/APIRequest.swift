//
//  APIResponse.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/10.
//

import Foundation
import UIKit

// MARK: - Request ----
protocol APIBaseRequest {
    associatedtype Response
    var path: String { get }
    var postData: Data? { get }
    var scheme: String { get }
    var host: String { get }
}

extension APIBaseRequest {
    var postData: Data? { nil }
}

extension APIBaseRequest {
    var scheme: String { "https"}
    var host: String { "api.nytimes.com" }
}

extension APIBaseRequest {
    private func createURLComponents(queryItems: [URLQueryItem]) -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components
    }
    
    private func createRequest(queryItems: [URLQueryItem]) -> URLRequest {
        let components = createURLComponents(queryItems: queryItems)
        let request: URLRequest = {
            var req = URLRequest(url: components.url!)
            if let data = postData {
                req.httpBody = data
                req.addValue("application/json", forHTTPHeaderField: "Content-Type")
                req.httpMethod = "POST"
            }
            return req
        }()
        return request
    }
    
}

extension APIBaseRequest where Response: Decodable {
    func send(queryItems: [URLQueryItem], completion: @escaping (Result<Response, Error>) -> Void) {
        let request = createRequest(queryItems: queryItems)
        URLSession.shared.dataTask(with: request) { data, response, error in
            do {
                if let data = data {
                    let decoded = try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(decoded))
                } else if let error = error {
                    completion(.failure(error))
                }
            } catch {
                print("SOMETHING ERROR HAPPEND IN REQUEST", error)
            }
        }.resume()
    }
}

