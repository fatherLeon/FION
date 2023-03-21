//
//  ContentType.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/21.
//

import Foundation

enum ContentType {
    case userInfo
    case userMatch
    case match
    
    var baseURL: URL? {
        return URL(string: "https://api.nexon.co.kr/fifaonline4/v1.0")
    }
}
