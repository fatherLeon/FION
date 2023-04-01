//
//  NetworkModel.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/21.
//

import Foundation

class NetworkModel {
    func makeRequest(contentType: ContentType) -> URLRequest? {
        guard let url = contentType.url else { return nil }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        return request
    }
    
    func fetchUserInfo(completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask {
        do {
            let url = try getUserInfoURL(items: [URLQueryItem(name: "nickname", value: nickName)])
            var request = URLRequest(url: url)
            
            request.addValue("\(Bundle.main.apiKey)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    completion(.failure(.networkError))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.responseError))
                    return
                }
                
                if let data = data {
                    do {
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
