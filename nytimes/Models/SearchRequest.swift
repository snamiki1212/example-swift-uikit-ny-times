//
//  SearchRequest.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/16.
//

import Foundation

struct SearchRequest: APIBaseRequest {
    typealias Response = SearchResponse
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
