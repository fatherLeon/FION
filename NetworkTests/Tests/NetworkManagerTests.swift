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

    override func setUpWithError() throws {
        let provider = MockAPIProvider()
        
        sut = NetworkManager(provider: provider, type: .match(matchid: "123"))
    }

    override func tearDownWithError() throws {
        sut = nil
    }
}
