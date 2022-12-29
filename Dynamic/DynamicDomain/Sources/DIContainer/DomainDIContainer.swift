//
//  DomainDIContainer.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

import DynamicCore

public final class DomainDIContainer: Containable {
    public init() {}
    
    public var container: BMOInject = DIContainer.shared
    
    public func register() {
        registerAddFavoritesUseCase()
        registerImageSearchUseCase()
        registerFetchFavoritesUseCase()
        registerRemoveFavoritesUseCase()
    }
}

extension DomainDIContainer {
    private func registerImageSearchUseCase() {
        guard let networkManager: NetworkManagerRepository = container.resolveValue(RepoKeys.network.rawValue),
              let coreDataManager: CoreDataManagerRepository = container.resolveValue(RepoKeys.coreManager.rawValue) else { return }
        let imageSearchUseCase = ImageSearchUseCase(manager: networkManager,
                                              coreDataManager: coreDataManager)
        container.registerValue(UCKeys.search.rawValue, imageSearchUseCase)
    }
    
    private func registerAddFavoritesUseCase() {
        guard let coreDataManager: CoreDataManagerRepository = container.resolveValue(RepoKeys.coreManager.rawValue) else {
                  return
              }
        let addFavoritesUseCase = AddFavoritesUseCase(coreDataManager: coreDataManager)
        container.registerValue(UCKeys.addFavorites.rawValue, addFavoritesUseCase)
    }
    
    private func registerFetchFavoritesUseCase() {
        guard let coreDataManager: CoreDataManagerRepository = container.resolveValue(RepoKeys.coreManager.rawValue) else { return }
        let fetchFavoritesUseCase = FetchFavoritesUseCase(coreDataManager: coreDataManager)
        container.registerValue(UCKeys.fetchFavorites.rawValue, fetchFavoritesUseCase)
    }
    
    private func registerRemoveFavoritesUseCase() {
        guard let coreDataManager: CoreDataManagerRepository = container.resolveValue(RepoKeys.coreManager.rawValue) else { return }
        let removeFavoritesUseCase = RemoveFavoritesUseCase(coreDataManager: coreDataManager)
        container.registerValue(UCKeys.removeFavorites.rawValue, removeFavoritesUseCase)
    }
}
