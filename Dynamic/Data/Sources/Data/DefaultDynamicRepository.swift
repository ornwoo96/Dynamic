//
//  DefaultDynamicRepository.swift
//  Data
//
//  Created by 김동우 on 2022/12/10.
//

import Foundation

import Domain

public final class DefaultDynamicRepository: DynamicRepository {
    public func fetchSomething() {
        print("fetch start")
    }
}
