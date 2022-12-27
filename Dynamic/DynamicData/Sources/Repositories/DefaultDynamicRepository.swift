//
//  DefaultDynamicRepository.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

import DynamicDomain

public final class DefaultDynamicImageDataRepository: DynamicImageDataRepository {
    private let manager: NetworkManager
    private let coreDataManager: CoreDataManagerRepository
    
    init(manager: NetworkManager,
         coreDataManager: CoreDataManagerRepository) {
        self.manager = manager
        self.coreDataManager = coreDataManager
    }
    
    public func retrieveGIPHYDatas(_ searchWord: String,
                                   _ offset: Int) async throws -> GIPHYDomainModel {
        let data = try await manager.fetchGIPHYDatas(searchWord, offset)
        let boolArray = try await coreDataManager.checkGIFImageArrayDataIsExist(createIdArray(data.previewImages))
        
        return convert(data, boolArray)
    }
}
