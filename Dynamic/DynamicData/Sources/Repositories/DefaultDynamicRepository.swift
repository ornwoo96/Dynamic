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
    
    public func retrieveGIPHYDatas() async throws -> GIPHYDomainModel {
        let data = try await manager.fetchGIPHYDatas()
        let boolArray = try await coreDataManager.checkGIFImageArrayDataIsExist(createIdArray(data.previewImages))
        
        return convert(data, boolArray)
    }
}

//MARK: DTO
extension DefaultDynamicImageDataRepository {
    private func createIdArray(_ previewAddIDEntity: [PreviewAddIDEntity]) -> [String] {
        var idArray: [String] = []

        (0..<previewAddIDEntity.count).forEach {
            idArray.append(previewAddIDEntity[$0].id)
        }
        
        return idArray
    }
    
    private func convert(_ data: GiphyImageEntity,
                         _ boolArray: [Bool]) -> GIPHYDomainModel {
        var previews: [PreviewDomainModel] = []
        var originals: [OriginalDomainModel] = []
        
        for i in 0..<data.originalImages.count {
            let preview: PreviewDomainModel = .init(id: data.previewImages[i].id,
                                                    height: data.previewImages[i].height,
                                                    width: data.previewImages[i].width,
                                                    url: data.previewImages[i].url,
                                                    favorite: boolArray[i])
            let original: OriginalDomainModel = .init(id: data.originalImages[i].id,
                                                      height: data.originalImages[i].height,
                                                      width: data.originalImages[i].width,
                                                      url: data.originalImages[i].url,
                                                      favorite: boolArray[i])
            previews.append(preview)
            originals.append(original)
        }
        
        return GIPHYDomainModel.init(previewImages: previews, originalImages: originals)
    }
}
