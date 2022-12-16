//
//  DetailModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/16.
//

import Foundation

public struct DetailModel {
    public let url: String
    public let width: String
    public let height: String
    
    public init(url: String,
                width: String,
                height: String) {
        self.url = url
        self.width = width
        self.height = height
    }
}
