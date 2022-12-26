//
//  CompositionalViewModel + DTO.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation
import DynamicDomain

extension ChildCompositionalViewModel {
    public func convert(_ data: CompositionalPresentationModel.OriginalModel) -> DetailModel {
        return DetailModel(url: data.url,
                           width: String(Int(data.width)),
                           height: String(Int(data.height)))
    }
    
    public func convertOriginalDomain(_ data: CompositionalPresentationModel.OriginalModel) -> OriginalDomainModel {
        return OriginalDomainModel.init(id: data.id,
                                        height: String(Int(data.height)),
                                        width: String(Int(data.width)),
                                        url: data.url,
                                        favorite: data.favorite)
    }
    
    public func convertCellModel(_ compositionalPresentationModel: [CompositionalPresentationModel.PreviewModel]) -> [CompositionalCellItem] {
        return compositionalPresentationModel.map {
            CompositionalCellItem.init(url: $0.url,
                                       favorite: $0.favorite,
                                       width: $0.width,
                                       height: $0.height)
        }
    }
    
    public func convertPresentationModel(_ GIPHYDomainModel: GIPHYDomainModel) -> CompositionalPresentationModel {
        return CompositionalPresentationModel(
            previewModel: GIPHYDomainModel.previewImages.map { convert($0) },
            originalModel: GIPHYDomainModel.originalImages.map { convert($0) }
        )
    }
    
    private func convert(_ previewDomainModel: PreviewDomainModel) -> CompositionalPresentationModel.PreviewModel {
        return CompositionalPresentationModel.PreviewModel
            .init(height: CGFloat(Int(previewDomainModel.height) ?? 0),
                  width: CGFloat(Int(previewDomainModel.width) ?? 0),
                  url: previewDomainModel.url,
                  id: previewDomainModel.id,
                  favorite: previewDomainModel.favorite)
    }
    
    private func convert(_ originalDomainModel: OriginalDomainModel) -> CompositionalPresentationModel.OriginalModel {
        return CompositionalPresentationModel.OriginalModel
            .init(height: CGFloat(Int(originalDomainModel.height) ?? 0),
                  width: CGFloat(Int(originalDomainModel.width) ?? 0),
                  url: originalDomainModel.url,
                  id: originalDomainModel.id,
                  favorite: originalDomainModel.favorite)
    }
}
