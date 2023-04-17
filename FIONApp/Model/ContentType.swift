//
//  ContentType.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/21.
//

import Foundation

enum ContentType {
    case userInfo(nickname: String)
    case userMatch(id: String, matchType: Int, offset: Int = 0, limit: Int = 100)
    case match(matchid: String)
    
    private var baseURL: URL? {
        return URL(string: "https://api.nexon.co.kr/fifaonline4/v1.0/")
    }
    
    private var scheme: String {
        return "https"
    }
    
    private var host: String {
        return "api.nexon.co.kr"
    }
    
    private var path: String {
        return "/fifaonline4/v1.0"
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
            
            userMatchURL?.append(path: "\(id)")
            userMatchURL?.append(path: "matches")
            
            let matchTypeQuery = URLQueryItem(name: "matchtype", value: "\(matchType)")
            let offsetQuery = URLQueryItem(name: "offset", value: "\(offset)")
            let limitQuery = URLQueryItem(name: "limit", value: "\(limit)")
            
            userMatchURL?.append(queryItems: [matchTypeQuery, offsetQuery, limitQuery])
            
            return userMatchURL
        case .match(let matchid):
            var matchURL = URL(string: "matches", relativeTo: self.baseURL)
            
            matchURL?.append(path: "\(matchid)")
            
            return matchURL
        }
    }
}
