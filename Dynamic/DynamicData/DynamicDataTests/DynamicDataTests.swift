//
//  DynamicDataTests.swift
//  DynamicDataTests
//
//  Created by 김동우 on 2022/12/11.
//

import XCTest
@testable import DynamicData

final class DynamicDataTests: XCTestCase {
    
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func checkFetchData() throws {
        let fetchDataService = FetchDataService()
        
        fetchDataService.fetchImageEntity()
    }
}
