//
//  CompositionalCellModel.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation

public class CompositionalCellModel: BaseCellItem {
    let imageURL: String
    let imageId: String
    let favorite: Bool
    
    init(imageURL: String,
         imageId: String,
         favorite: Bool) {
        self.imageURL = imageURL
        self.imageId = imageId
        self.favorite = favorite
    }
}
