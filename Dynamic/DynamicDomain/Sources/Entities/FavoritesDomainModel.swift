//
//  FavoritesDomainModel.swift
//  DynamicDomain
//
//  Created by 김동우 on 2022/12/17.
//

import Foundation

public struct FavoriteDomainModel {
    public static let empty: Self = .init(url: "", width: "", height: "", id: "")
    
    public let url: String
    public let width: String
    public let height: String
    public let id: String
    
    public init(url: String,
                width: String,
                height: String,
                id: String) {
        self.url = url
        self.width = width
        self.height = height
        self.id = id
    }
}
