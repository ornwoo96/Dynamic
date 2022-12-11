//
//  DefaultDynamicRepository.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

import DynamicDomain

public final class DefaultDynamicRepository: DynamicRepository {
    public func fetchSomething() {
        print("fetch start")
    }
}
