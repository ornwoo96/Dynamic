//
//  AddFavoriteUseCase.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation

public final class AddFavoritesUseCase: AddFavoritesUseCaseProtocol {
    public var coreDataManager: CoreDataManagerRepository

    init(coreDataManager: CoreDataManagerRepository) {
        self.coreDataManager = coreDataManager
    }
    
    public func requestCoreDataCreateImageData(_ data: PreviewDomainModel) {
        coreDataManager.createGIFImageData(data.height, data.width, data.id, data.url)
    }
}
