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
        registerRepositories()
    }
    
    private func registerRepositories() {
        registerCoreDataManager()
        registerDynamicRepository()
    }
}

extension DataDIContainer {
    private func registerDynamicRepository() {
        let networkManager = NetworkManager()
        let api = GIPHYAPI(networkManager: networkManager)
        let dynamicRepository = DefaultDynamicRepository(GIPHYAPI: api)
        
        container.registerValue(RepoKeys.dynamicRepo.rawValue, dynamicRepository)
    }
    
    private func registerCoreDataManager() {
        let manager = DefaultCoreDataManagerRepository.shared
        
        container.registerValue(RepoKeys.coreManager.rawValue, manager)
    }
}
