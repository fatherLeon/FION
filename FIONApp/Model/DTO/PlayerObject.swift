//
//  PlayerObject.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/21.
//

import Foundation

struct PlayerObject: Decodable {
    struct PlayerInfoObject: Decodable {
        let id: String
        let name: String
    }
    
    let players: [PlayerInfoObject]
    
    init(from decoder: Decoder) throws {
        players = try decoder.singleValueContainer().decode([PlayerInfoObject].self)
    }
}
