//
//  NetworkManager.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/01.
//

import UIKit

struct NetworkManager {
    private var type: ContentType
    private let networkModel: APIProvider
    
    init(session: URLSession = .shared, type: ContentType) {
        self.networkModel = APIProvider(session: session)
        self.type = type
    }
    
    mutating func changeContentType(_ type: ContentType) {
        self.type = type
    }
    
    func fetchDataByJson<T>(to decodingType: T.Type, handler: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        guard let request = networkModel.makeRequest(contentType: self.type) else {
            handler(.failure(.invalidURL))
            return
        }
        
        let task = networkModel.makeURLSessionDataTask(request: request) { result in
            switch result {
            case .success(let data):
                guard let decodingData = DecoderModel().decodeToJson(type: decodingType, by: data) else {
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
                let image = DecoderModel().decodeToImage(by: data)
                handler(.success(image))
            case .failure(let error):
                handler(.failure(error))
            }
        }
        
        task?.resume()
    }
}
