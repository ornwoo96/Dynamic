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
    
    public func convert(_ originalDomainModel: [OriginalDomainModel]) -> [CustomPresentationModel.PresentationOriginal] {
        return originalDomainModel.map {
            CustomPresentationModel.PresentationOriginal.init(height: $0.height,
                                                              width: $0.width,
                                                              url: $0.url,
                                                              id: $0.id,
                                                              favorite: $0.favorite)
        }
    }
}
