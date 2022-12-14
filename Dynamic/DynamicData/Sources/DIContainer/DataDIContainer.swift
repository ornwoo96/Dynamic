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
        let fetchDataService = FetchDataService()
        
        container.registerValue(RepoKeys.fetchService.rawValue, fetchDataService)
    }
    
    private func registerRepositories() {
        guard let service: FetchDataService = container.resolveValue(RepoKeys.fetchService.rawValue) else { return }
        let repository = DefaultDynamicRepository(fetchDataService: service)
        
        container.registerValue(RepoKeys.DynamicRepo.rawValue, repository)
    }
}
