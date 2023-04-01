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
    
    func fetchData<T: Decodable>(handler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let request = networkManager.makeRequest(contentType: self.type) else {
            handler(.failure(.invalidURL))
            return
        }
        
        let task = networkManager.makeURLSessionDataTask(request: request) { result in
            switch result {
            case .success(let data):
                
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
