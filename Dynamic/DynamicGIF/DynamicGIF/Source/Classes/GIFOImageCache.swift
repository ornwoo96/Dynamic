//
//  GIFOImageCache.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/03/07.
//

import UIKit

internal class GIFOImageCache {
    internal static let shared = GIFOImageCache()

    private let cache = NSCache<NSString, GIFOImageCacheItem>()

    internal func addGIFImages(_ images: [GIFOFrame], forKey key: String) {
        let item = GIFOImageCacheItem(images: images)
        cache.setObject(item, forKey: key as NSString)
    }
    
    internal func getGIFImages(forKey key: String) -> [GIFOFrame]? {
        guard let item = cache.object(forKey: key as NSString) else { return nil }
        return item.images
    }
    
    internal func checkCachedImage(forKey key: String) -> Bool {
        if self.cache.object(forKey: key as NSString) != nil {
            return true
        } else {
            return false
        }
    }
    
    internal func removeGIFImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}
