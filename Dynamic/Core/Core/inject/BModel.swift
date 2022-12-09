//
//  BModel.swift
//  Core
//
//  Created by 김동우 on 2022/12/09.
//

import Foundation

public struct BModel<T> {
    let key: String
    var value: T
    
    init(key: String, value: T) {
        self.key = key
        self.value = value
    }
}
