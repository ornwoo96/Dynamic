//
//  CoreTests.swift
//  CoreTests
//
//  Created by 김동우 on 2022/12/09.
//

import XCTest
@testable import Core

final class CoreTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let Bmo = BMOInject()
        var viewController: UIViewController = TestViewController()
        Bmo.registerValue("dd", viewController)
        
        
        guard let testData: TestViewController = Bmo.resolveValue("dd") else { return }
        
        print(testData)
    }

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
