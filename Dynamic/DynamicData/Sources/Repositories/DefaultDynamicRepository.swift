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
    
    init(manager: NetworkManager) {
        self.manager = manager
    }
    
    public func retrieveGIPHYDatas() async throws -> GIPHYDomainModel {
        let data = try await manager.fetchGIPHYDatas()
        
        return convertToDomainModel(data)
    }
    
    private func convertToDomainModel(_ data: GiphyImageEntity) -> GIPHYDomainModel {
        var previews: [PreviewDomainModel] = []
        var originals: [OriginalDomainModel] = []
        for i in 0..<data.originalImages.count {
            let preview: PreviewDomainModel = .init(id: data.previewImages[i].id,
                                                    height: data.previewImages[i].height,
                                                    width: data.previewImages[i].width,
                                                    url: data.previewImages[i].url)
            let original: OriginalDomainModel = .init(id: data.originalImages[i].id,
                                                      height: data.originalImages[i].height,
                                                      width: data.originalImages[i].width,
                                                      url: data.originalImages[i].url)
            previews.append(preview)
            originals.append(original)
        }
        
        return GIPHYDomainModel.init(previewImages: previews, originalImages: originals)
    }
}
