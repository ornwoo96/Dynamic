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
    func retrieveGIFImage(_ url: String) async throws -> Data
    func requestCoreDataManagerForCreateImageData(_ data: OriginalDomainModel)
    func requestRemoveImageDataFromCoreData(_ id: String)
    func retrieveGIPHYDataFromCoreData() async throws -> [FavoriteDomainModel]
}
