//
//  DetailModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/16.
//

import Foundation

public struct DetailModel {
    public let detailImage: Data
    public let width: String
    public let height: String
    
    public init(detailImage: Data,
                width: String,
                height: String) {
        self.detailImage = detailImage
        self.width = width
        self.height = height
    }
}
