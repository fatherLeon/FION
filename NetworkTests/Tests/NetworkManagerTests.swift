//
//  NetworkManagerTests.swift
//  NetworkTests
//
//  Created by 강민수 on 2023/04/18.
//

import XCTest
@testable import FIONApp

final class NetworkManagerTests: XCTestCase {
    
    struct MockAPIProvider: Providable {
        
        private let session: URLSession
        
        init() {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            
            let session = URLSession(configuration: configuration)
            
            self.session = session
        }
        
        func makeRequest(contentType: ContentType) -> URLRequest? {
            let request = URLRequest(url: contentType.url!)
            
            return request
        }
        
        func makeURLSessionDataTask(request: URLRequest, completion: @escaping ((Result<Data, NetworkError>) -> Void)) -> URLSessionDataTask? {
            
            let task = session.dataTask(with: request) { data, response, _ in
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    completion(.failure(.responseError(400)))
                    return
                }
                
                guard let data = data else { return }
                
                completion(.success(data))
            }
            
            return task
        }
    }

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
}
