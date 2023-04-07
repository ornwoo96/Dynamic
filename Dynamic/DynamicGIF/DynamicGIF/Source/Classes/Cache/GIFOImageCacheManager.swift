//
//  GIFOImageCache.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/03/07.
//

import UIKit

internal class GIFOImageCacheManager: NSObject {
    internal static let shared = GIFOImageCacheManager()

    private let GIFOFrameCache = NSCache<NSString, GIFOImageCacheItem>()
    private let UIImageCache = NSCache<NSString, UIImageCacheItem>()
    private var GIFOFrameCacheItemWithTimestampArray: [CacheItemWithTimestamp]?
    private var UIImageCacheItemWithTimestampArray: [CacheItemWithTimestamp]?
    private var GIFOFrameTotalCost = 0
    private var UIImageTotalCost = 0
    private let UIImageCacheMaxCost = 25 * 1024 * 1024
    private let GIFOFrameCacheMaxCost = 25 * 1024 * 1024
    
    override init() {
        super.init()
        self.UIImageCache.totalCostLimit = UIImageCacheMaxCost
        self.GIFOFrameCache.totalCostLimit = GIFOFrameCacheMaxCost
        self.UIImageCache.delegate = self
        self.GIFOFrameCache.delegate = self
    }
    
    internal enum CacheType {
        case GIFFrame
        case UIImage
    }
    
    internal func addGIFImages(_ cacheType: CacheType,
                               images: [Any],
                               forKey key: String) {
    
        switch cacheType {
        case .GIFFrame:
            guard let images = images as? [GIFOFrame] else { return }
            let item = GIFOImageCacheItem(frames: images)
            addCacheItemWithTimestampArray(.GIFFrame, key)
            addCost(cacheType, item.sizeInBytes ?? 0)
            GIFOFrameCache.setObject(item, forKey: key as NSString)
        case .UIImage:
            guard let images = images as? [UIImage] else { return }
            let item = UIImageCacheItem(frames: images)
            addCacheItemWithTimestampArray(.UIImage, key)
            addCost(cacheType, item.sizeInBytes ?? 0)
            UIImageCache.setObject(item, forKey: key as NSString)
        }
    }
    
    internal func getGIFImages(_ type: CacheType,
                               forKey key: String) -> [Any]? {
        switch type {
        case .GIFFrame:
            guard let item = GIFOFrameCache.object(forKey: key as NSString) else { return nil }
            return item.frames
        case .UIImage:
            guard let item = UIImageCache.object(forKey: key as NSString) else { return nil }
            return item.frames
        }
    }
    
    internal func checkCachedImage(_ type: CacheType,
                                   forKey key: String) -> Bool {
        switch type {
        case .GIFFrame:
            if self.GIFOFrameCache.object(forKey: key as NSString) != nil {
                return true
            }
            return false
        case .UIImage:
            if self.UIImageCache.object(forKey: key as NSString) != nil {
                return true
            }
            return false
        }
    }
    
    internal func removeImageCache(_ type: CacheType,
                                   forKey key: String) {
        switch type {
        case .GIFFrame:
            GIFOFrameCache.removeObject(forKey: key as NSString)
        case .UIImage:
            UIImageCache.removeObject(forKey: key as NSString)
        }
    }
    
    internal func removeAllImageCache(_ type: CacheType) {
        switch type {
        case .GIFFrame:
            GIFOFrameCache.removeAllObjects()
        case .UIImage:
            UIImageCache.removeAllObjects()
        }
    }
}

extension GIFOImageCacheManager: NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>,
               willEvictObject obj: Any) {
        switch obj {
        case _ as GIFOImageCacheItem:
            if let cacheItem = obj as? GIFOImageCacheItem {
                GIFOFrameTotalCost -= cacheItem.sizeInBytes ?? 0
                print("Removed data from cache")
            }
        case _ as UIImageCacheItem:
            if let cacheItem = obj as? UIImageCacheItem {
                UIImageTotalCost -= cacheItem.sizeInBytes ?? 0
                print("Removed data from cache")
            }
        default: break
        }
    }
    
    private func addCost(_ cacheType: CacheType,
                         _ sizeInBytes: Int) {
        switch cacheType {
        case .GIFFrame:
            self.GIFOFrameTotalCost += sizeInBytes
            if self.GIFOFrameTotalCost > self.GIFOFrameCacheMaxCost {
                removeOldestCacheItem(cacheType)
            }
        case .UIImage:
            self.UIImageTotalCost += sizeInBytes
            if self.UIImageTotalCost > self.UIImageCacheMaxCost {
                removeOldestCacheItem(cacheType)
            }
        }
    }
    
    private func addCacheItemWithTimestampArray(_ type: CacheType,
                                                _ key: String) {
        switch type {
        case .GIFFrame:
            let item = CacheItemWithTimestamp(key: key as NSString,
                                              createdTimestamp: Date())
            
            GIFOFrameCacheItemWithTimestampArray?.append(item)
        case .UIImage:
            let item = CacheItemWithTimestamp(key: key as NSString,
                                              createdTimestamp: Date())
            
            UIImageCacheItemWithTimestampArray?.append(item)
        }
    }
    
    private func removeOldestCacheItem(_ type: CacheType) {
        switch type {
        case .GIFFrame:
            guard let oldestItem = getOldestItem(type) as? CacheItemWithTimestamp,
                  let oldestItemIndex = getOldestIndex(type, oldestItem) else { return }
            GIFOFrameCache.removeObject(forKey: oldestItem.key)
            GIFOFrameCacheItemWithTimestampArray?.remove(at: oldestItemIndex)
            
        case .UIImage:
            guard let oldestItem = getOldestItem(type) as? CacheItemWithTimestamp,
                  let oldestItemIndex = getOldestIndex(type, oldestItem) else { return }
            UIImageCache.removeObject(forKey: oldestItem.key)
            UIImageCacheItemWithTimestampArray?.remove(at: oldestItemIndex)
        }
    }
    
    private func getOldestItem(_ type: CacheType) -> Any? {
        switch type {
        case .GIFFrame:
            if let oldestItem = GIFOFrameCacheItemWithTimestampArray?.min(by: {
                $0.createdTimestamp < $1.createdTimestamp
            }) {
                return oldestItem
            }
            return nil
            
        case .UIImage:
            if let oldestItem = UIImageCacheItemWithTimestampArray?.min(by: {
                $0.createdTimestamp < $1.createdTimestamp
            }) {
                return oldestItem
            }
            return nil
        }
    }
    
    private func getOldestIndex(_ type: CacheType,
                                _ oldestItem: CacheItemWithTimestamp) -> Int? {
        switch type {
        case .GIFFrame:
            if let index = GIFOFrameCacheItemWithTimestampArray?.firstIndex(where: {
                $0.key == oldestItem.key
            }) {
                return index
            }
            return nil
            
        case .UIImage:
            if let index = UIImageCacheItemWithTimestampArray?.firstIndex(where: {
                $0.key == oldestItem.key
            }) {
                return index
            }
            return nil
        }
    }
}
