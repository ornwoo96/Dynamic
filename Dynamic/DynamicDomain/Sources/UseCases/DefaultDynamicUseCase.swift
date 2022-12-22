//
//  DynamicUseCase.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

public final class DefaultDynamicUseCase: DynamicUseCase {
    public var dynamicRepository: DynamicImageDataRepository
    public var coreDataManager: CoreDataManagerRepository
    
    init(dynamicRepository: DynamicImageDataRepository,
         coreDataManager: CoreDataManagerRepository) {
        self.dynamicRepository = dynamicRepository
        self.coreDataManager = coreDataManager
    }
    
    public func retrieveGIPHYDatas() async throws -> GIPHYDomainModel {
        return try await dynamicRepository.retrieveGIPHYDatas()
    }
    
    public func requestRemoveImageDataFromCoreData(_ id: String) {
        coreDataManager.removeGIFImageData(id)
    }
    
    public func retrieveGIPHYDataFromCoreData() async throws -> [FavoriteDomainModel] {
        return try await coreDataManager.requestFavoritesDatas()
    }
    
    public func requestCoreDataCreateImageData(_ data: OriginalDomainModel) {
        coreDataManager.createGIFImageData(data.height, data.width, data.id, data.url)
    }
}
