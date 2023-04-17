//
//  ContentTypeTests.swift
//  ContentTypeTests
//
//  Created by 강민수 on 2023/04/01.
//

@testable import FIONApp
import XCTest

final class ContentTypeTests: XCTestCase {
    
    var sut: ContentType!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    func test_isCorrectUserInfoURL() {
        // given
        sut = ContentType.userInfo(nickname: "cheslea")
        
        let expectation = "https://api.nexon.co.kr/fifaonline4/v1.0/users?nickname=cheslea"
        
        // when
        let result = sut.url!.absoluteString
        
        // then
        XCTAssertEqual(expectation, result)
    }
    
    func test_isCorrectUserMatchURL() {
        // given
        sut = ContentType.userMatch(id: "1234", matchType: 60, offset: 100, limit: 20)
        
        let expectation = "https://api.nexon.co.kr/fifaonline4/v1.0/users/1234/matches?matchtype=60&offset=100&limit=20"
        
        // when
        let result = sut.url!.absoluteString
        
        XCTAssertEqual(expectation, result)
    }
    
    func testisCorrectMatchURL() {
        // given
        sut = ContentType.match(matchid: "1234")
        
        let expectation = "https://api.nexon.co.kr/fifaonline4/v1.0/matches/1234"
        
        // when
        let result = sut.url!.absoluteString
        
        // then
        XCTAssertEqual(expectation, result)
    }
}
