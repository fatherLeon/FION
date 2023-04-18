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
    case allMatch(matchtype: Int = 50, offset: Int = 0, limit: Int = 100, orderby: String = "desc")
    
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
        var basicPath = "/fifaonline4/v1.0"
        
        switch self {
        case .userInfo(_):
            basicPath.append("/users")
        case .userMatch(let id, _, _, _):
            basicPath.append("/users/\(id)/matches")
        case .match(let matchid):
            basicPath.append("/matches/\(matchid)")
        case .allMatch(_, _, _, _):
            basicPath.append("/matches")
        }
        
        return basicPath
    }
    
    private var querys: [URLQueryItem]? {
        switch self {
        case .userInfo(let nickname):
            let nicknameQuery = URLQueryItem(name: "nickname", value: nickname)
            
            return [nicknameQuery]
        case .userMatch(_, let matchType, let offset, let limit):
            let matchTypeQuery = URLQueryItem(name: "matchtype", value: "\(matchType)")
            let offsetQuery = URLQueryItem(name: "offset", value: "\(offset)")
            let limitQuery = URLQueryItem(name: "limit", value: "\(limit)")
            
            return [matchTypeQuery, offsetQuery, limitQuery]
        case .match(_):
            return nil
        case .allMatch(let matchtype, let offset, let limit, let orderby):
            let matchtypeQuery = URLQueryItem(name: "matchtype", value: "\(matchtype)")
            let offsetQuery = URLQueryItem(name: "offset", value: "\(offset)")
            let limitQuery = URLQueryItem(name: "limit", value: "\(limit)")
            let orderbyQuery = URLQueryItem(name: "orderby", value: orderby)
            
            return [matchtypeQuery, offsetQuery, limitQuery, orderbyQuery]
        }
    }
    
    var url: URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = self.scheme
        urlComponents.host = self.host
        urlComponents.path = self.path
        urlComponents.queryItems = self.querys
        
        return urlComponents.url
    }
}
