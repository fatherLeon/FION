//
//  NetworkModel.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/21.
//

import Foundation

class NetworkModel {
    let contentType: ContentType = .userInfo
    
    func getUserInfoURL(items: [URLQueryItem]) throws -> URL {
        var userInfoURL = URL(string: "users", relativeTo: contentType.baseURL)
        userInfoURL = userInfoURL?.appending(queryItems: items)
        
        guard let url = userInfoURL else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    func fetchUserInfo<Fetchable>(_ nickName: String, completion: @escaping (Result<Fetchable, NetworkError>) -> Void) where Fetchable: Decodable {
        
        do {
            let url = try getUserInfoURL(items: [URLQueryItem(name: "nickname", value: nickName)])
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard error != nil,
                      let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.networkError))
                    return
                }
                
                if let data = data {
                    do {
                        let decodingData = try JSONDecoder().decode(Fetchable.self, from: data)
                        completion(.success(decodingData))
                    } catch {
                        completion(.failure(.decodingError))
                        return
                    }
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(.invalidURL))
            return
        }
    }
}
