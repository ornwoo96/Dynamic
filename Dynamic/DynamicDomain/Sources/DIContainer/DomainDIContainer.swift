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
        registerUseCases()
    }
    
    private func registerUseCases() {
        guard let dynamicRepository: DynamicImageDataRepository = container.resolveValue(RepoKeys.DynamicRepo.rawValue) else { return }
        let dynamicUseCase = DefaultDynamicUseCase(dynamicRepository: dynamicRepository)
        container.registerValue(UCKeys.DynamicUC.rawValue, dynamicUseCase)
    }
}
