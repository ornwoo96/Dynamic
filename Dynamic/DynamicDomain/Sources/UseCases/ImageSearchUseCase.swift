//
//  ImageSearchUseCase.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation

public final class ImageSearchUseCase: ImageSearchUseCaseProtocol {
    private let manager: NetworkManagerRepository
    private let coreDataManager: CoreDataManagerRepository
    
    init(manager: NetworkManagerRepository,
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
