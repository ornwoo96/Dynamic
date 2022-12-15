//
//  ImageCacheManager.swift
//  DynamicData
//
//  Created by 김동우 on 2022/12/15.
//

import Foundation

public final class ImageCacheManager {
    static let shared = NSCache<NSURL, NSData>()
    
    init() {}
}
