//
//  DynamicUseCase.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

public final class DefaultDynamicUseCase: DynamicUseCase {
    public var dynamicRepository: DynamicImageDataRepository
    public var imageCacheRepository: ImageCacheRepository
    public var coreDataManager: CoreDataManagerRepository
    
    init(dynamicRepository: DynamicImageDataRepository,
         imageCacheRepository: ImageCacheRepository,
         coreDataManager: CoreDataManagerRepository) {
        self.dynamicRepository = dynamicRepository
        self.imageCacheRepository = imageCacheRepository
        self.coreDataManager = coreDataManager
    }
    
    public func retrieveGIPHYDatas() async throws -> GIPHYDomainModel {
        return try await dynamicRepository.retrieveGIPHYDatas()
    }
    
    public func retrieveGIFImage(_ url: String,
                                 _ id: String) async throws -> (Data, Bool) {
        return try await imageCacheRepository.imageLoad(url, id)
    }
    
    public func requestCoreDataManagerForCreateImageData(_ data: OriginalDomainModel) {
        Task { [weak self] in
            do {
                guard let imageData = try await self?.retrieveGIFImage(data.url, data.id) else {
                    print("request imageData 실패")
                    return
                }
                self?.coreDataManager.createGIFImageData(data.height, data.width, data.id, imageData.0)
            } catch {
                print("DefaultDynamicUseCase request Create CoreDataEntity - 실패")
            }
        }
    }
    
    public func requestRemoveImageDataFromCoreData(_ id: String) {
        coreDataManager.removeGIFImageData(id)
    }
    
    public func retrieveGIPHYDataFromCoreData() async throws -> [FavoriteDomainModel] {
        return try await coreDataManager.requestFavoritesDatas()
    }
}
