//
//  Article.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/16.
//

import Foundation

struct Article: Codable {
    static let multimediaPrefixUrl = "https://static01.nyt.com/"
    // REF: https://developer.nytimes.com/docs/articlesearch-product/1/types/Article
    
    // TODO: add alot of proparties
    let _id: String
    let web_url: String
    let snippet: String
    let headline: Headline
    let multimedia: [Multimedia]
    var webUrl: URL? {
        return URL(string: self.web_url)
    }
    var imageUrl: URL? {
        guard let pickedIdx = multimedia.firstIndex(where: {media in   media.subType == "xlarge" } ) else { return nil }
        let picked = multimedia[pickedIdx]
        
        let strUrl = Article.multimediaPrefixUrl + picked.url
        return URL(string: strUrl)
    }
    
    struct Headline: Codable {
        let main: String
    }

    struct Multimedia: Codable {
        let subType: String
        let url: String
    }
}
