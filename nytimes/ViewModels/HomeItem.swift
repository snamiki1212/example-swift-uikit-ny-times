//
//  HomeItem.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/15.
//

import Foundation

typealias HomeItem = Article
extension HomeItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs._id == rhs._id
    }
}
