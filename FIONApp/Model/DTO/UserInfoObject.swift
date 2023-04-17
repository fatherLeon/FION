//
//  UserInfo.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/20.
//

import Foundation

struct UserInfoObject: Decodable {
    let userId: String
    let name: String
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "accessId"
        case name = "nickname"
        case level
    }
}
