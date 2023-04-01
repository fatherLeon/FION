//
//  ContentType.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/21.
//

import Foundation

enum ContentType {
    case userInfo(nickname: String)
    // https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname={nickname}
    case userMatch(id: String, matchType: Int, offset: Int = 0, limit: Int = 100)
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
        case .userMatch(let id, let matchType, let offset, let limit):
            var userMatchURL = URL(string: "users", relativeTo: self.baseURL)
            userMatchURL = URL(string: id, relativeTo: userMatchURL)
            userMatchURL = URL(string: "\(matchType)", relativeTo: userMatchURL)
            
            let matchTypeQuery = URLQueryItem(name: "matchtype", value: "\(matchType)")
            let offsetQuery = URLQueryItem(name: "offset", value: "\(offset)")
            let limitQuery = URLQueryItem(name: "limit", value: "\(limit)")
            
            userMatchURL?.append(queryItems: [matchTypeQuery, offsetQuery, limitQuery])
            
            return userMatchURL
        default:
            return nil
        }
    }
}
