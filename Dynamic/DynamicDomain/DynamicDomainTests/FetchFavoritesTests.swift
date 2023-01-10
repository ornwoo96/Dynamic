//
//  FetchFavoritesTests.swift
//  DynamicDomainTests
//
//  Created by 김동우 on 2022/12/30.
//

import XCTest
@testable import DynamicDomain
import DynamicData
import DynamicCore

final class FetchFavoritesTests: XCTestCase {
    private func testInteraction() throws -> FetchFavoritesUseCase {
        let dataDIContainer = DataDIContainer()
        dataDIContainer.register()
        guard let coreDataManager: CoreDataManagerRepository = DIContainer.shared.resolveValue(RepoKeys.coreManager.rawValue) else {
            throw BMOInjectError.resolveError
        }
        
        let fetchFavoritesUseCase = FetchFavoritesUseCase(coreDataManager: coreDataManager)
        return fetchFavoritesUseCase
    }
    
    func testRequestFavoritesImageDataCountInCoreData() async throws {
        // Given
        let fetchFavoritesUseCase = try testInteraction()
        
        // When
        let dataCount = try await fetchFavoritesUseCase.requestFavoritesImageDataCountInCoreData()
        
        // Then
        XCTAssertEqual(dataCount, 2)
    }
}
