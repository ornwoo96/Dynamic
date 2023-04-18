//
//  DetailModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/16.
//

import Foundation

internal struct DetailModel {
    let url: String
    let width: String
    let height: String
    
    init(url: String,
                width: String,
                height: String) {
        self.url = url
        self.width = width
        self.height = height
    }
}
