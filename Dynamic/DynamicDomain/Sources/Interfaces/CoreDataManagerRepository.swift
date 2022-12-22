//
//  CoreDataManagerRepository.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/17.
//

import Foundation

public protocol CoreDataManagerRepository {
    func createGIFImageData(_ height: String,
                            _ width: String,
                            _ id: String,
                            _ url: String)
    func removeGIFImageData(_ id: String)
    func checkGIFImageDataIsExist(_ id: String) async throws -> Bool
    func requestFavoriteData(_ id: String) async throws -> FavoriteDomainModel
    func requestFavoritesDatas() async throws -> [FavoriteDomainModel]
    func checkGIFImageArrayDataIsExist(_ array: [String]) async throws -> [Bool]
}
