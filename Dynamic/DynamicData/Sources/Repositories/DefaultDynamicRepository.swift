//
//  DynamicAdapter.swift
//  DynamicDataTests
//
//  Created by 김동우 on 2022/12/29.
//

import Foundation
import DynamicDomain

public final class DefaultDynamicRepository: DynamicRepository {
    private let GIPHYAPI: GIPHYAPI
    
    init(GIPHYAPI: GIPHYAPI) {
        self.GIPHYAPI = GIPHYAPI
    }
    
    public func retrieveGIFImageData(searchWord: String,
                                     offset: Int) async throws -> GIPHYDomainModel {
        let model = try await GIPHYAPI.retrieveGIFImageData(searchWord: searchWord,
                                                            offset: offset)
        return convertToDomainModel(model)
    }
}

extension DefaultDynamicRepository {
    public func convertToDomainModel(_ data: GiphyImageDataModel) -> GIPHYDomainModel {
        return .init(
            previewImages: data.previewImages.map { convertToDomainPreviewModel($0) },
            originalImages: data.originalImages.map { convertToDomainOriginalModel($0) }
        )
    }
    
    private func convertToDomainPreviewModel(_ data: GiphyImageDataModel.PreviewAddIDEntity) -> PreviewDomainModel {
        return .init(id: data.id, height: data.height, width: data.width, url: data.url)
    }
    
    private func convertToDomainOriginalModel(_ data: GiphyImageDataModel.OriginalAddIDEntity) -> OriginalDomainModel {
        return .init(id: data.id, height: data.height, width: data.width, url: data.url)
    }
}
