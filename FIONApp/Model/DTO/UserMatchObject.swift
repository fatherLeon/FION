//
//  UserMatch.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/20.
//

import Foundation

struct UserMatchObject: Decodable {
    let matchIds: [String]
    
    init(from decoder: Decoder) throws {
        matchIds = try decoder.singleValueContainer().decode([String].self)
    }
}
