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
        sut = APIProvider()
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
    
    func test_validDataTask() {
        // given
        let contentType = ContentType.match(matchid: "123")
        let request = sut.makeRequest(contentType: contentType)
        
        // when
        
        // then
    }
}
