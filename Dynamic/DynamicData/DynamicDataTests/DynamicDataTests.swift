//
//  DynamicDataTests.swift
//  DynamicDataTests
//
//  Created by 김동우 on 2022/12/11.
//

import XCTest
import DynamicDomain
@testable import DynamicData

final class DynamicDataTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testFetchGIPHYDatas() async throws {
        // given
        let networkManager = NetworkManager()
        let expectation = expectation(description: "200")
        var resultDataCount = 0
        
        // when
        let testData = try await networkManager.fetchGIPHYDatas("coding", 0)
        resultDataCount = testData.originalImages.count
        expectation.fulfill()
        wait(for: [expectation], timeout: 5)
        
        // then
        XCTAssertEqual(resultDataCount, 20)
    }
    
    
    
}
