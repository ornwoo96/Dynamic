//
//  DataDIContainer.swift
//  Data
//
//  Created by 김동우 on 2022/12/10.
//

import Foundation

import Core
import Domain

public final class DataDIContainer: Containable {
    public var container: Core.BMOInject = DIContainer.shared
    
    public init() {}
    
    public func register() {
        registerRepositories()
    }
    
    private func registerRepositories() {
        let repository = DefaultDynamicRepository()
        
        container.registerValue(RepoKeys.DynamicRepo.rawValue, repository)
    }
}
