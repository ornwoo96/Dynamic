//
//  DynamicUseCase.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/11.
//

import Foundation

public protocol DynamicUseCase {
    var dynamicRepository: DynamicImageDataRepository { get }
    
    func retrieveGIPHYDatas() async throws -> GIPHYDomainModel
}
