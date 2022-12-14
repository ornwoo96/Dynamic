//
//  CoreTests.swift
//  CoreTests
//
//  Created by 김동우 on 2022/12/09.
//

import XCTest
@testable import DynamicCore

final class CoreTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testBMOInject() throws {
        // given
        let Bmo = BMOInject()
        var viewController: UIViewController = TestViewController()
        Bmo.registerValue("dd", viewController)
        
        // when
        guard let testData: TestViewController = Bmo.resolveValue("dd") else { return }
        
        // then
        XCTAssertEqual(viewController, testData)
    }
}
