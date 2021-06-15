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
    var queryItems: [URLQueryItem]? { get }
    var request: URLRequest { get }
    var postData: Data? { get }
    var scheme: String { get }
    var host: String { get }
}

extension APIBaseRequest {
    var queryItems: [URLQueryItem]? { nil }
    var postData: Data? { nil }
}

extension APIBaseRequest {
    var scheme: String { "https"}
    var host: String { "api.nytimes.com" }
}

extension APIBaseRequest {
    var request: URLRequest {
        let components: URLComponents = {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.path = path
            components.queryItems = queryItems
            return components
        }()
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
    func send(completion: @escaping (Result<Response, Error>) -> Void) {
        print("SEND")
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

// MARK: - services----
struct ArticleSearchRequest: APIBaseRequest {
    typealias Response = SearchEntireResponse
    // TODO: path
    // var path = "/search/v2/articlesearch.json"
//    var path = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=\(NY_TIMES_API_KEY)"
    var path: String = "/svc/search/v2/articlesearch.json"
    var queryItems: [URLQueryItem]? {
        return [
            URLQueryItem(name: "q", value: "election"),
            URLQueryItem(name: "api-key", value: NY_TIMES_API_KEY),
        ]
    }
}


// MARK: - Response --------------------------------------------
struct SearchEntireResponse {
    let status: String
    let copyright: String
    let response: SearchResponse
}

extension SearchEntireResponse: Codable {}

struct SearchResponse {
    let docs: [ArticleResponse]
    let meta: ResponseMeta
}

extension SearchResponse: Codable {}

struct ArticleResponse {
    // REF: https://developer.nytimes.com/docs/articlesearch-product/1/types/Article
    
    // TODO: add alot of proparties
    let _id: String
    let web_url: String
    let headline: Headline
    let multimedia: [Multimedia]
    var imageUrl: String {
        guard let pickedIdx = multimedia.firstIndex(where: {media in   media.subType == "xlarge" } ) else { return "" }
        let picked = multimedia[pickedIdx]
        
        return ArticleResponse.multimediaPrefixUrl + picked.url
    }
    static let multimediaPrefixUrl = "https://static01.nyt.com/"
}
extension ArticleResponse: Codable {}

struct Headline {
    let main: String
}
extension Headline: Codable {}

struct Multimedia {
    let subType: String
    let url: String
}

extension Multimedia: Codable{}

struct ResponseMeta {
    let hits: Int
    let offset: Int
    let time: Int
}
extension ResponseMeta: Codable {}

// MARK: - ErrorResponse ---
struct ErrorResponse : Codable {
    var fault: FaultBody
}
struct FaultBody: Codable {
    var faultstring: String
    var detail: DetailBody
}
struct DetailBody: Codable {
    var errorcode: String
}
