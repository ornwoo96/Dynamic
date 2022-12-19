//
//  FavoritesDomainModel.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/17.
//

import Foundation

public struct FavoriteDomainModel {
    public static let empty: Self = .init(data: Data(), width: "", height: "", id: "")
    
    public let data: Data
    public let width: String
    public let height: String
    public let id: String
    
    public init(data: Data,
                width: String,
                height: String,
                id: String) {
        self.data = data
        self.width = width
        self.height = height
        self.id = id
    }
}
