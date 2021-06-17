//
//  ErrorResponse.swift
//  nytimes
//
//  Created by shunnamiki on 2021/06/16.
//

import Foundation

struct ErrorResponse : Codable {
    var fault: FaultBody
    struct FaultBody: Codable {
        var faultstring: String
        var detail: DetailBody
        struct DetailBody: Codable {
            var errorcode: String
        }
    }
}


