//
//  NetworkModel.swift
//  FIONApp
//
//  Created by 강민수 on 2023/03/21.
//

import Foundation

struct NetworkModel {
    let session: URLSession
    
    func makeRequest(contentType: ContentType) -> URLRequest? {
        guard let url = contentType.url else { return nil }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("\(Bundle.main.apiKey)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func makeURLSessionDataTask(request: URLRequest, completion: @escaping ((Result<Data, NetworkError>) -> Void)) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.networkError))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.responseError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            
            completion(.success(data))
        }
        
        return task
    }
}
