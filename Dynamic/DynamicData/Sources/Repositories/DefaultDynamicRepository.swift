//
//  DefaultDynamicRepository.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

import DynamicDomain

public final class DefaultDynamicRepository: DynamicRepository {
    private let fetchDataService: FetchDataService
    
    init(fetchDataService: FetchDataService) {
        self.fetchDataService = fetchDataService
    }
    
    public func fetchSomething() {
        print("fetch start")
        fetchDataService.fetchImageEntity()
    }
}
