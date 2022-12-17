//
//  CoreDataManagerRepository.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/17.
//

import Foundation

public protocol CoreDataManagerRepository {
    func createGIFImageData(_ data: OriginalDomainModel)
    func removeGIFImageData(_ data: OriginalDomainModel)
    func checkGIFImageDataIsExist() async throws -> Bool
}
