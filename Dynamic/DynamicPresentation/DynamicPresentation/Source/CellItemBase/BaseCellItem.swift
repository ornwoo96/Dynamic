//
//  BaseCellItem.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/21.
//

import Foundation

public class BaseCellItem: Hashable {
    var id: String = ""
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: BaseCellItem, rhs: BaseCellItem) -> Bool {
        lhs.id == rhs.id
    }
}
