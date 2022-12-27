//
//  DynamicRepository.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

public protocol DynamicImageDataRepository {
    func retrieveGIPHYDatas(_ searchWord: String,
                            _ offset: Int) async throws -> GIPHYDomainModel
}
