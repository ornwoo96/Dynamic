//
//  DataDIContainer.swift
//  Data
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

import DynamicCore

public final class DataDIContainer: Containable {
    public var container: BMOInject = DIContainer.shared
    
    public init() {}
    
    public func register() {
        registerRepositories()
    }
    
    private func registerRepositories() {
        let repository = DefaultDynamicRepository()
        
        container.registerValue(RepoKeys.DynamicRepo.rawValue, repository)
    }
}
