//
//  SearchRequest.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/16.
//

import Foundation

struct SearchRequest: APIBaseRequest {
    typealias Response = SearchResponse
    var path: String = "/svc/search/v2/articlesearch.json"
    static func createQueryItems(searchText: String) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "q", value: searchText),
            URLQueryItem(name: "api-key", value: NY_TIMES_API_KEY),
        ]
    }
}

extension SearchRequest {
    func search(searchText: String, completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        let queryItems = SearchRequest.createQueryItems(searchText: searchText)
        send(queryItems: queryItems, completion: completion)
    }
    
    func fetch(completion: @escaping (Result<SearchResponse, Error>) -> Void) {
        search(searchText: "", completion: completion)
    }
}
