//
//  DomainDIContainer.swift
//  Domain
//
//  Created by 김동우 on 2022/12/10.
//

import Foundation

import Core

public final class DomainDIContainer: Containable {
    public init() {}
    
    public var container: BMOInject = DIContainer.shared
    
    public func register() {
        registerUseCases()
    }
    
    private func registerUseCases() {
        guard let dynamicRepository: DynamicRepository = container.resolveValue("DynamicRepository"),
              let dynamicUseCase = DefaultD else { return }
        
        container.registerValue("DynamicUseCase", <#T##value: Service##Service#>)
    }
}
