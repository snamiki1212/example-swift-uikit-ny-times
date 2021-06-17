//
//  SearchResponse.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/16.
//

import Foundation

struct SearchResponse: Codable {
    let status: String
    let copyright: String
    let response: SearchInnerResponse
    
    struct SearchInnerResponse: Codable {
        let docs: [Article]
        let meta: ResponseMeta
        
        struct ResponseMeta: Codable {
            let hits: Int
            let offset: Int
            let time: Int
        }
    }
}


