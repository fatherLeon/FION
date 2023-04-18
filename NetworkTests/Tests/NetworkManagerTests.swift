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
        func makeRequest(contentType: FIONApp.ContentType) -> URLRequest? {

        }
        
        func makeURLSessionDataTask(request: URLRequest, completion: @escaping ((Result<Data, FIONApp.NetworkError>) -> Void)) -> URLSessionDataTask? {

        }
    }

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
}
