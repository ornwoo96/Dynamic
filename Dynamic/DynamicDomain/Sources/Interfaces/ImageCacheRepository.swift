//
//  ImageCacheRepository.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/15.
//

import Foundation

public protocol ImageCacheRepository {
    func imageLoad(_ url: String, _ id: String) async throws -> (Data, Bool)
}
