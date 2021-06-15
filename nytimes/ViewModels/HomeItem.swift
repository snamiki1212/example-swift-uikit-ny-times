//
//  HomeItem.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/15.
//

import Foundation

typealias HomeItem = ArticleResponse
extension HomeItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
    
    static func == (lhs: ArticleResponse, rhs: ArticleResponse) -> Bool {
        lhs._id == rhs._id
    }
}

extension HomeItem {
    static func createExample() -> ArticleResponse {
        let id = UUID.init().uuidString
        let headline = Headline(main: "this is headline")
        let multimedia = Multimedia(subType: "xlarge", url: "images/2021/06/14/lens/14xp-dogs/merlin_177669612_2c5d593f-2e57-4a15-ae69-dbbffa5fd626-articleLarge.jpg")
        return ArticleResponse(_id: id, web_url: "WEB_URL" + id, headline: headline, multimedia: [multimedia])
    }
    
    static func createExampleList() -> [HomeItem] {
        return [
            HomeItem.createExample(),
            HomeItem.createExample(),
            HomeItem.createExample(),
            HomeItem.createExample(),
            HomeItem.createExample(),
            HomeItem.createExample(),
            HomeItem.createExample(),
        ]
    }
}
