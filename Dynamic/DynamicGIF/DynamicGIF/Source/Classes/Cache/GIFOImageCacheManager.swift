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
    
    override init() {
        super.init()
        self.UIImageCache.countLimit = 40
        self.GIFOFrameCache.countLimit = 3
    }
    
    internal enum CacheType {
        case GIFFrame
        case UIImage
    }
    
    internal func addGIFImages(images: [GIFOFrame],
                               forKey key: String) {
        let item = GIFOImageCacheItem(frames: images)
        GIFOFrameCache.setObject(item, forKey: key as NSString)
    }
    
    internal func addGIFUIImage(image: UIImage,
                                forKey key: String) {
        let item = UIImageCacheItem(frame: image)
        UIImageCache.setObject(item, forKey: key as NSString)
    }
    
    internal func getGIFImages(forKey key: String) -> [GIFOFrame]? {
        guard let item = GIFOFrameCache.object(forKey: key as NSString) else {
            return nil
        }
        return item.frames
    }
    
    internal func getGIFUIImage(forKey key: String) -> UIImage? {
        guard let item = UIImageCache.object(forKey: key as NSString) else {
            return nil
        }
        
        return item.frame
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
