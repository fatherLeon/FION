//
//  NetworkManager.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/01.
//

import UIKit

final class NetworkManager<T> {
    private let type: ContentType
    private let networkModel: APIProvider
    
    init(session: URLSession = .shared, type: ContentType) {
        self.networkModel = APIProvider(session: session)
        self.type = type
    }
    
    func fetchDataByJson(handler: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        guard let request = networkModel.makeRequest(contentType: self.type) else {
            handler(.failure(.invalidURL))
            return
        }
        
        let task = networkModel.makeURLSessionDataTask(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodingData = self?.decodingToJson(data: data) else {
                    handler(.failure(.decodingError))
                    return
                }
                
                handler(.success(decodingData))
            case .failure(let error):
                handler(.failure(error))
            }
        }
        
        task?.resume()
    }
    
    func fetchDataByImage(handler: @escaping (Result<UIImage?, NetworkError>) -> Void) {
        guard let request = networkModel.makeRequest(contentType: self.type) else {
            handler(.failure(.invalidURL))
            return
        }
        
        let task = networkModel.makeURLSessionDataTask(request: request) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                handler(.success(image))
            case .failure(let error):
                handler(.failure(error))
            }
        }
        
        task?.resume()
    }
    
    private func decodingToJson(data: Data) -> T? where T: Decodable{
        do {
            let decodingData = try JSONDecoder().decode(T.self, from: data)
            return decodingData
        } catch {
            return nil
        }
    }
}
