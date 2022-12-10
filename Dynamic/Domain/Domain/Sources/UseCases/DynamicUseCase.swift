//
//  DynamicUseCase.swift
//  Domain
//
//  Created by 김동우 on 2022/12/10.
//

import Foundation

public final class DefaultDynamicUseCase: DynamicUseCase {
    public var dynamicRepository: DynamicRepository
    
    init(dynamicRepository: DynamicRepository) {
        self.dynamicRepository = dynamicRepository
    }
    
    public func doSomething() {
        print("dynamicUseCase start")
        dynamicRepository.fetchSomething()
    }
}
