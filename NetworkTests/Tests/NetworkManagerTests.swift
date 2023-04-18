//
//  NetworkManagerTests.swift
//  NetworkTests
//
//  Created by 강민수 on 2023/04/18.
//

import XCTest
@testable import FIONApp

final class NetworkManagerTests: XCTestCase {
    
    private var sut: NetworkManager!
    private let contentType: ContentType = .match(matchid: "123")

    override func setUpWithError() throws {
        let provider = MockAPIProvider()
        
        sut = NetworkManager(provider: provider, type: contentType)
    }

    override func tearDownWithError() throws {
        sut = nil
        MockURLProtocol.requestHandler = nil
    }
    
    func test_fetchMatch() {
        // given
        let url = contentType.url!
        let request = URLRequest(url: url)
        let expectation = XCTestExpectation()
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            let data = StubData.matchData
            
            return (response, data)
        }
        
        // when
        sut.fetchDataByJson(to: MatchObject.self) { event in
            switch event {
            case .success(let data):
                XCTAssertEqual("63f18d93e982f639cfe3822c", data.matchID)
                XCTAssertEqual("2023-02-19T11:56:59", data.matchDate)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Incorrect Test Case")
            }
        }
        
        // then
        wait(for: [expectation], timeout: 3)
    }
}
