//
//  FetchFavoritesUseCase.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation

protocol FetchFavoritesUseCaseProtocol {
    func retrieveGIPHYDataFromCoreData() async throws -> [FavoriteDomainModel]
    func requestFavoritesImageDataCountInCoreData() async throws -> Int
}
