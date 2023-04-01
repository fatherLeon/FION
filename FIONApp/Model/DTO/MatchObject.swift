//
//  Match.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/20.
//

import Foundation

struct MatchObject: Decodable {
    let id: String
    let date: String
    let type: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "matchId"
        case date = "matchDate"
        case type = "matchType"
    }
}
