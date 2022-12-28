//
//  NetworkManagerRepository.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation

public protocol NetworkManagerRepository {
    func fetchGIPHYDatas(_ searchWord: String,
                         _ offset: Int) async throws -> GIPHYDomainModel
    func fetchImageData(_ url: String) async throws -> Data
}

