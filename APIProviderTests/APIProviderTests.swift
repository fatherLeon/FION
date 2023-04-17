//
//  APIProviderTests.swift
//  APIProviderTests
//
//  Created by 강민수 on 2023/04/17.
//

import XCTest
@testable import FIONApp

final class APIProviderTests: XCTestCase {
    
    private var sut: APIProvider!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let session = URLSession(configuration: configuration)
        
        sut = APIProvider(session: session)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_validRequest() {
        // given
        let contentType = ContentType.match(matchid: "123")
        let httpMethodExpectation = "GET"
        let urlExpectation = contentType.url
        
        // when
        let request = sut.makeRequest(contentType: contentType)
        
        // then
        XCTAssertEqual(request?.httpMethod, httpMethodExpectation)
        XCTAssertEqual(request?.url, urlExpectation)
    }
    
    func test_validSuccessResponseDataTask() {
        // given
        let contentType = ContentType.match(matchid: "123")
        let request = sut.makeRequest(contentType: contentType)!
        let expectation = XCTestExpectation()
        let data = "abc".data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { (request) in
            let urlResponse = HTTPURLResponse(url: contentType.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            
            return (urlResponse, data)
        }
        
        // when
        let task = sut.makeURLSessionDataTask(request: request, completion: { event in
            switch event {
            case .success(let result):
                XCTAssertEqual(data, result)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Incorrect Test Case")
            }
        })!
        
        task.resume()
        
        // then
        wait(for: [expectation], timeout: 3)
        
        let resultResponseCode = task.response as! HTTPURLResponse
        
        XCTAssertEqual(resultResponseCode.statusCode, 200)
    }
}
