//
//  GIFOImageCache.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/03/07.
//

import UIKit

internal class GIFOImageCache: NSObject {
    internal static let shared = GIFOImageCache()

    private let GIFOFrameCache = NSCache<NSString, GIFOImageCacheItem>()
    private let UIImageCache = NSCache<NSString, UIImageCacheItem>()
    
    private var totalCost = 0
    private let maxCost = 300 * 1024 * 1024
    
    override init() {
        self.UIImageCache.totalCostLimit = maxCost
        self.GIFOFrameCache.totalCostLimit = maxCost
    }

    internal func addGIFImagesWithGIFOFrame(_ images: [GIFOFrame], forKey key: String) {
        let item = GIFOImageCacheItem(frames: images)
        GIFOFrameCache.setObject(item, forKey: key as NSString)
    }
    
    internal func addGIFImagesWithUIImage(_ images: [UIImage], forKey key: String) {
        let item = UIImageCacheItem(frames: images)
        UIImageCache.setObject(item, forKey: key as NSString)
    }
    
    internal func getGIFImagesWithGIFOFrame(forKey key: String) -> [GIFOFrame]? {
        guard let item = GIFOFrameCache.object(forKey: key as NSString) else { return nil }
        return item.frames
    }
    
    internal func getGIFImagesWithUIImage(forKey key: String) -> [UIImage]? {
        guard let item = UIImageCache.object(forKey: key as NSString) else { return nil }
        return item.frames
    }
    
    internal func checkCachedImageWithGIFOFrame(forKey key: String) -> Bool {
        if self.GIFOFrameCache.object(forKey: key as NSString) != nil {
            return true
        } else {
            return false
        }
    }
    
    internal func checkCachedImageWithUIImage(forKey key: String) -> Bool {
        if self.UIImageCache.object(forKey: key as NSString) != nil {
            return true
        } else {
            return false
        }
    }
    
    internal func removeGIFImageWithGIFOFrame(forKey key: String) {
        GIFOFrameCache.removeObject(forKey: key as NSString)
    }
    
    internal func removeGIFImageWithUIImage(forKey key: String) {
        UIImageCache.removeObject(forKey: key as NSString)
    }
    
    internal func removeAllImageWithGIFOFrame() {
        GIFOFrameCache.removeAllObjects()
    }
    
    internal func removeAllImageWithUIImage() {
        UIImageCache.removeAllObjects()
    }
    
    private func removeOldData() {
    }
}

extension GIFOImageCache: NSCacheDelegate {
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let nsData = obj as? NSData {
            totalCost -= nsData.length
            print("Removed data from cache")
        }
    }
}
