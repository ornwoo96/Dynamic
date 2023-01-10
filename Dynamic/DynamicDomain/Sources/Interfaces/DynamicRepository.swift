//
//  DynamicRepository.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/29.
//

import Foundation

public protocol DynamicRepository {
    func retrieveGIFImageData(searchWord: String,
                              offset: Int) async throws -> GIPHYDomainModel
}
