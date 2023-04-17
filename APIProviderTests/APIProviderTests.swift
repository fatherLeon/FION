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
        
        MockURLProtocol.requestHandler = { (request) in
            let urlResponse = URLResponse(url: contentType.url!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
            let data = "abc".data(using: .utf8)!
            
            return (urlResponse, data)
        }
        
        // when
        let task = sut.makeURLSessionDataTask(request: request, completion: { _ in })
        let resultResponseCode = task!.response as! HTTPURLResponse
        
        // then
        XCTAssertEqual(resultResponseCode.statusCode, 200)
    }
}
