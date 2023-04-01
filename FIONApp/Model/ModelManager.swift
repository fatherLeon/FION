//
//  ModelManager.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/01.
//

import Foundation

final class ModelManager<T> {
    private let type: ContentType
    private let networkManager: NetworkManager
    
    init(session: URLSession = .shared, type: ContentType) {
        self.networkManager = NetworkManager(session: session)
        self.type = type
    }
    
    func fetchDataByJson<T: Decodable>(handler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let request = networkManager.makeRequest(contentType: self.type) else {
            handler(.failure(.invalidURL))
            return
        }
        
        let task = networkManager.makeURLSessionDataTask(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = self?.decodingToJson(data: data, type: T.self) else {
                    handler(.failure(.decodingError))
                    return
                }
                
                handler(.success(data))
            case .failure(let error):
                handler(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    
    private func decodingToJson<T: Decodable>(data: Data, type: T.Type) -> T? {
        do {
            let decodingData = try JSONDecoder().decode(type, from: data)
            
            return decodingData
        } catch {
            return nil
        }
    }
}
