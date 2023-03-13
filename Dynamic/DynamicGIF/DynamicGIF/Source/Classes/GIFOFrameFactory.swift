//
//  GIFFrameFactory.swift
//  GIFO
//
//  Created by BMO on 2023/03/06.
//

import UIKit

public enum GIFFrameReduceLevel {
    case highLevel
    case middleLevel
    case lowLevel
}

internal class GIFOFrameFactory {
    internal var animationFrames: [GIFOFrame] = []
    private var imageSource: CGImageSource?
    private var imageSize: CGSize
    private var contentMode: UIView.ContentMode
    internal var totalFrameCount: Int?
    private var isResizing: Bool = false
    
    init(data: Data,
         size: CGSize,
         contentMode: UIView.ContentMode = .scaleAspectFill,
         isResizing: Bool = false) {
        let options = [String(kCGImageSourceShouldCache): kCFBooleanFalse] as CFDictionary
        self.imageSource = CGImageSourceCreateWithData(data as CFData, options) ?? CGImageSourceCreateIncremental(options)
        self.imageSize = size
        self.contentMode = contentMode
        self.isResizing = isResizing
    }
    
    internal func clearFactory() {
        self.animationFrames = []
        self.imageSource = nil
        self.totalFrameCount = 0
        self.isResizing = false
    }
    
    internal func setupGIFImageFrames(cacheKey: String,
                                      level: GIFFrameReduceLevel = .highLevel,
                                      animationOnReady: @escaping () -> Void) {
        guard let imageSource = self.imageSource else {
            return
        }
        
        let frames = convertCGImageSourceToGIFFrameArray(source: imageSource)
        let levelFrames = getLevelFrame(level: level, frames: frames)
        self.animationFrames = levelFrames
        
        saveCacheImageFrames(cacheKey: cacheKey,
                             frames: levelFrames)
        animationOnReady()
    }
    
    internal func setupCachedImageFrames(cacheKey: String,
                                         level: GIFFrameReduceLevel = .highLevel,
                                         animationOnReady: @escaping () -> Void) {
        guard let cgImages = GIFOImageCache.shared.getGIFImages(forKey: cacheKey) else {
            print("get cachedImages - failure")
            return
        }
        self.animationFrames = cgImages
        self.totalFrameCount = cgImages.count
        animationOnReady()
    }
    
    private func getLevelFrame(level: GIFFrameReduceLevel,
                               frames: [GIFOFrame]) -> [GIFOFrame] {
        switch level {
        case .highLevel:
            return frames
        case .middleLevel:
            return reduceFrames(GIFFrames: frames, level: 2)
        case .lowLevel:
            return reduceFrames(GIFFrames: frames, level: 3)
        }
    }
    
    private func convertCGImageSourceToGIFFrameArray(source: CGImageSource) -> [GIFOFrame] {
        let frameCount = CGImageSourceGetCount(source)
        var frameProperties: [GIFOFrame] = []
        
        for i in 0..<frameCount {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                return []
            }
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any] else {
                return []
            }
            
            if isResizing {
                guard let resizeImage = resize(source,i,image) else { return [] }
                
                frameProperties.append(
                    GIFOFrame(image: resizeImage,
                             duration: applyMinimumDelayTime(properties))
                )
            } else {
                frameProperties.append(
                    GIFOFrame(image: image,
                             duration: applyMinimumDelayTime(properties))
                )
            }
        }
        
        return frameProperties
    }
    
    private func saveCacheImageFrames(cacheKey: String,
                                      frames: [GIFOFrame]) {
        GIFOImageCache.shared.addGIFImages(frames, forKey: cacheKey)
    }
    
    private func applyMinimumDelayTime(_ properties: [String: Any]) -> Double {
        var duration = 0.1

        if let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
            duration = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
        }
        
        if duration < 0.1 {
            return 0.1
        }
        
        return duration
    }
    
    private func reduceFrames(GIFFrames: [GIFOFrame],
                              level: Int) -> [GIFOFrame] {
        let frameCount = GIFFrames.count
        let reducedFrameCount = max(frameCount/level, 1)
        
        var reducedFrameProperties: [GIFOFrame] = []
        
        for i in 0..<reducedFrameCount {
            var gifFrame = GIFOFrame.empty
            let originalFrameIndex = i * level
            
            gifFrame.image = GIFFrames[originalFrameIndex].image
            gifFrame.duration = GIFFrames[originalFrameIndex].duration * Double(level)
            
            reducedFrameProperties.append(gifFrame)
        }
        
        totalFrameCount = reducedFrameProperties.count
        
        return reducedFrameProperties
    }
    
    private func resize(_ source: CGImageSource,
                        _ index: Int,
                        _ cgImage: CGImage) -> CGImage? {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: max(Int(self.imageSize.width), Int(self.imageSize.height))
        ]
        
        guard let thumbnailImage = CGImageSourceCreateThumbnailAtIndex(source, index, options as CFDictionary) else {
            return nil
        }
        
        return thumbnailImage
    }
}
