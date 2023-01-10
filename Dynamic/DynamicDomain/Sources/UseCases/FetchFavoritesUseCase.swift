//
//  FetchFavoritesUseCase.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation

public final class FetchFavoritesUseCase: FetchFavoritesUseCaseProtocol {
    private var coreDataManager: CoreDataManagerRepository
    
    init(coreDataManager: CoreDataManagerRepository) {
        self.coreDataManager = coreDataManager
    }
    
    public func retrieveGIPHYDataFromCoreData() async throws -> [FavoriteDomainModel] {
        return try await coreDataManager.requestFavoritesDatas()
    }
    
    public func requestFavoritesImageDataCountInCoreData() async throws -> Int {
        let favoritesData = try await coreDataManager.requestFavoritesDatas()
        return favoritesData.count
    }
}
