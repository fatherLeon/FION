//
//  NetworkManager.swift
//  FIONApp
//
//  Created by 강민수 on 2023/04/01.
//

import UIKit

final class NetworkManager {
    private var type: ContentType
    private let provider: Providable
    private var task: URLSessionDataTask?
    private var isStopSession: Bool = false
    
    init(provider: Providable = APIProvider(session: .shared), type: ContentType) {
        self.provider = provider
        self.type = type
    }
    
    func changeContentType(_ type: ContentType) {
        self.type = type
    }
    
    func fetchDataByJson<T>(to decodingType: T.Type, handler: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        guard !isStopSession else {
            task?.cancel()
            return
        }
        
        guard let request = provider.makeRequest(contentType: self.type) else {
            handler(.failure(.invalidURL))
            return
        }
        
        task = provider.makeURLSessionDataTask(request: request) { result in
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
        guard !isStopSession else {
            task?.cancel()
            return
        }
        
        guard let request = provider.makeRequest(contentType: self.type) else {
            handler(.failure(.invalidURL))
            return
        }
        
        task = provider.makeURLSessionDataTask(request: request) { result in
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
