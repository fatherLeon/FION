//
//  APIURLs.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/05.
//

import Foundation

enum APIURLs: String {
    case playerSpid = "https://static.api.nexon.co.kr/fifaonline4/latest/spid.json"
    
    var url: URL {
        guard let encodedURL = self.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedURL) else {
            return URL(string: self.rawValue)!
        }
        
        return url
    }
}
