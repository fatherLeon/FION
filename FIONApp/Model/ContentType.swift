//
//  ContentType.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/21.
//

import Foundation

enum ContentType {
    case userInfo(String)
    // https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname={nickname}
    case userMatch
    case match
    
    private var baseURL: URL? {
        return URL(string: "https://api.nexon.co.kr/fifaonline4/v1.0/")
    }
    
    var url: URL? {
        switch self {
        case .userInfo(let nickname):
            var userURL = URL(string: "users", relativeTo: self.baseURL)
            let nicknameQuery = URLQueryItem(name: "nickname", value: nickname)
            
            userURL?.append(queryItems: [nicknameQuery])
            
            return userURL
        default:
            return nil
        }
    }
}
