//
//  DataDIContainer.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

import DynamicCore
import CoreData

public final class DataDIContainer: Containable {
    public var container: BMOInject = DIContainer.shared
    
    public init() {}
    
    public func register() {
        registerFetchDataService()
        registerRepositories()
    }
    
    private func registerFetchDataService() {
        let networkManager = NetworkManager()
        
        container.registerValue(RepoKeys.network.rawValue, networkManager)
    }
    
    private func registerRepositories() {
        registerCoreDataManager()
        registerDynamicImageDataRepository()
    }
}

extension DataDIContainer {
    private func registerDynamicImageDataRepository() {
        guard let manager: NetworkManager = container.resolveValue(RepoKeys.network.rawValue),
              let coredataManager: DefaultCoreDataManagerRepository = container.resolveValue(RepoKeys.coreManager.rawValue) else { return }
        let repository = DefaultDynamicImageDataRepository(manager: manager,
                                                           coreDataManager: coredataManager)
        
        container.registerValue(RepoKeys.dynamicRepo.rawValue, repository)
    }
    
    private func registerCoreDataManager() {
        let manager = DefaultCoreDataManagerRepository.shared
        
        container.registerValue(RepoKeys.coreManager.rawValue, manager)
    }
}
