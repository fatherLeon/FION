//
//  UserMatch.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/20.
//

import Foundation
// https://api.nexon.co.kr/fifaonline4/v1.0/users/{accessid}/matches?matchtype={matchtype}&offset={offset}&limit={limit}

struct UserMatch: Decodable {
    let matchIds: [String]
}
