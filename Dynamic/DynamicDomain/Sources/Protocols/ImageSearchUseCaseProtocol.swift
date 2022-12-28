//
//  ImageSearchUseCaseProtocol.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/28.
//

import Foundation

protocol ImageSearchUseCaseProtocol {
    func retrieveGIPHYDatas(_ searchWord: String,
                            _ offset: Int) async throws -> GIPHYDomainModel
}
