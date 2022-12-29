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
        let boolArray = try await coreDataManager.checkGIFImageArrayDataIsExist(createIDArray(data.previewImages))
        
        return mergeBoolArrayInDomainModel(data, boolArray)
    }
}

extension ImageSearchUseCase {
    private func mergeBoolArrayInDomainModel(_ data: GIPHYDomainModel,
                                             _ array: [Bool]) -> GIPHYDomainModel {
        var previews: [PreviewDomainModel] = []
        var originals: [OriginalDomainModel] = []
        
        for i in 0..<data.originalImages.count {
            let preview: PreviewDomainModel = .init(id: data.previewImages[i].id,
                                                    height: data.previewImages[i].height,
                                                    width: data.previewImages[i].width,
                                                    url: data.previewImages[i].url,
                                                    favorite: array[i])
            let original: OriginalDomainModel = .init(id: data.originalImages[i].id,
                                                      height: data.originalImages[i].height,
                                                      width: data.originalImages[i].width,
                                                      url: data.originalImages[i].url,
                                                      favorite: array[i])
            previews.append(preview)
            originals.append(original)
        }
        
        return .init(previewImages: previews, originalImages: originals)
    }
    
    private func createIDArray(_ previewArray: [PreviewDomainModel]) -> [String] {
        return previewArray.map { $0.id }
    }
    
}
