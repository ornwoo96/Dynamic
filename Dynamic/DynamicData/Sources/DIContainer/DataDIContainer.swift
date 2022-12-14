//
//  DataDIContainer.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

import DynamicCore

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
        guard let manager: NetworkManager = container.resolveValue(RepoKeys.network.rawValue) else { return }
        let repository = DefaultDynamicImageDataRepository(manager: manager)
        
        container.registerValue(RepoKeys.DynamicRepo.rawValue, repository)
    }
}
