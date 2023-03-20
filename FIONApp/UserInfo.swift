//
//  UserInfo.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/20.
//

import Foundation

// https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname={nickname}
struct UserInfo: Decodable {
    let userId: String
    let name: String
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "accessid"
        case name = "nickname"
        case level
    }
}
