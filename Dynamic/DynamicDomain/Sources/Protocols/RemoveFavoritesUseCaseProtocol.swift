//
//  RemoveFavoritesUseCase.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation

protocol RemoveFavoritesUseCaseProtocol {
    func requestRemoveImageDataFromCoreData(_ id: String)
}
