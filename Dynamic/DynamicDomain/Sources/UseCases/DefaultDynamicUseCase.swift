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
    
    init(dynamicRepository: DynamicImageDataRepository,
         imageCacheRepository: ImageCacheRepository) {
        self.dynamicRepository = dynamicRepository
        self.imageCacheRepository = imageCacheRepository
    }
    
    public func retrieveGIPHYDatas() async throws -> GIPHYDomainModel {
        return try await dynamicRepository.retrieveGIPHYDatas()
    }
    
    public func retrieveGIFImage(_ url: String) async throws -> Data {
        return try await imageCacheRepository.imageLoad(url)
    }
}
