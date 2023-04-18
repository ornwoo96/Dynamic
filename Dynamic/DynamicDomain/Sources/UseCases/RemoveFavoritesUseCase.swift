//
//  RemoveFavoritesUseCase.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation

internal final class RemoveFavoritesUseCase: RemoveFavoritesUseCaseProtocol {
    private var coreDataManager: CoreDataManagerRepository
    
    init(coreDataManager: CoreDataManagerRepository) {
        self.coreDataManager = coreDataManager
    }
    
    public func requestRemoveImageDataFromCoreData(_ id: String) {
        coreDataManager.removeGIFImageData(id)
    }
}
