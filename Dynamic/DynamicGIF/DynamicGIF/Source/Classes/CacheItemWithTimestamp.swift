//
//  CacheItemWithTimestamp.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/04/05.
//

import Foundation

struct CacheItemWithTimestamp<Key: Hashable> {
    let key: Key
    let createdTimestamp: Date
}
