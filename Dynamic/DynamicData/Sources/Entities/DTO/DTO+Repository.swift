//
//  DTO+TODomain.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/14.
//

import Foundation

extension GIPHYFromAPIEntity {
    public func convertGiphyImageEntity() -> GiphyImageEntity {
        return .init(previewImages: convertPreviewImageData(giphyData),
                     originalImages: convertOriginalImageData(giphyData))
    }
    
    public func convertPreviewImageData(_ data: [GiphyData]) -> [PreviewAddIDEntity] {
        var previewData: [PreviewAddIDEntity] = []
        for i in 0..<data.count {
            let result = PreviewAddIDEntity(id: data[i].id,
                                            height: data[i].images.previewGIF.height,
                                            width: data[i].images.previewGIF.width,
                                            url: data[i].images.previewGIF.url)
            previewData.append(result)
        }
        
        return previewData
    }
    
    public func convertOriginalImageData(_ data: [GiphyData]) -> [OriginalAddIDEntity] {
        var originalData: [OriginalAddIDEntity] = []
        for i in 0..<data.count {
            let result = OriginalAddIDEntity(id: data[i].id,
                                             height: data[i].images.original.height,
                                             width: data[i].images.original.width,
                                             url: data[i].images.original.url)
            originalData.append(result)
        }
        
        return originalData
    }
}
