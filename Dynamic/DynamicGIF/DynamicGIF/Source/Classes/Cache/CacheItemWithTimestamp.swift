//
//  CacheItemWithTimestamp.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/04/05.
//

import Foundation

struct CacheItemWithTimestamp: Hashable {
    let key: NSString
    let createdTimestamp: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    static func == (lhs: CacheItemWithTimestamp,
                    rhs: CacheItemWithTimestamp) -> Bool {
        return lhs.key == rhs.key
    }
}
