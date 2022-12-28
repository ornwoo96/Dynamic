//
//  CustomViewModel + DTO.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation
import DynamicDomain

extension CustomViewModel {
    public func convert(_ presentationOriginal: CustomPresentationModel.PresentationOriginal) -> OriginalDomainModel {
        return OriginalDomainModel(id: presentationOriginal.id,
                                   height: String(Int(presentationOriginal.height)),
                                   width: String(Int(presentationOriginal.width)),
                                   url: presentationOriginal.url,
                                   favorite: true)
    }

    public func convert(_ indexPath: Int, _ presentationOriginal: [CustomPresentationModel.PresentationOriginal]) -> DetailModel {
        return DetailModel(url: presentationOriginal[indexPath].url,
                           width: String(Int(presentationOriginal[indexPath].width)),
                           height: String(Int(presentationOriginal[indexPath].height)))
    }

    public func convert(_ previewDomainModel: [PreviewDomainModel]) -> [CustomPresentationModel.PresentationPreview] {
        return previewDomainModel.map {
            CustomPresentationModel.PresentationPreview.init(height: $0.height,
                                                             width: $0.width,
                                                             url: $0.url,
                                                             id: $0.id,
                                                             favorite: $0.favorite)
        }
    }
    
    public func convertCustomPresentationModel(_ giphyDomainModel: GIPHYDomainModel) -> CustomPresentationModel {
        return CustomPresentationModel.init(previewImageData: giphyDomainModel.previewImages.map { convert($0) },
                                            originalImageData: giphyDomainModel.originalImages.map { convert($0) })
        
    }
    
    private func convert(_ previewDomainModel: PreviewDomainModel) -> CustomPresentationModel.PresentationPreview {
        return CustomPresentationModel.PresentationPreview(height: previewDomainModel.height,
                                                           width: previewDomainModel.width,
                                                           url: previewDomainModel.url,
                                                           id: previewDomainModel.id,
                                                           favorite: previewDomainModel.favorite)
    }
    
    private func convert(_ originalDomainModel: OriginalDomainModel) -> CustomPresentationModel.PresentationOriginal {
        return CustomPresentationModel.PresentationOriginal(height: originalDomainModel.height,
                                                            width: originalDomainModel.width,
                                                            url: originalDomainModel.url,
                                                            id: originalDomainModel.id,
                                                            favorite: originalDomainModel.favorite)
    }
}
