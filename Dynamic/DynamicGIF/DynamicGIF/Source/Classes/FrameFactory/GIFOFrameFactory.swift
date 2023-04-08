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
    private var imageSource: CGImageSource?
    private var imageSize: CGSize
    private var isResizing: Bool = false
    private var cacheKey: String?
    private var frameDurations: [Double]?
    private var memoryLimit = 300
    
    internal var animationGIFOFrames: [GIFOFrame]?
    internal var animationUIImageFrames: [UIImage]?
    internal var totalFrameCount: Int?
    internal var animationTotalDuration = 0.0
    
    init(data: Data,
         size: CGSize,
         isResizing: Bool = false) {
        let options = [String(kCGImageSourceShouldCache): kCFBooleanFalse] as CFDictionary
        self.imageSource = CGImageSourceCreateWithData(data as CFData, options) ?? CGImageSourceCreateIncremental(options)
        self.imageSize = size
        self.isResizing = isResizing
    }
    
    internal func clearFactory(completion: @escaping ()->Void) {
        self.animationGIFOFrames = []
        self.imageSource = nil
        self.totalFrameCount = 0
        self.isResizing = false
        GIFOImageCacheManager.shared.removeImageCache(.GIFFrame, forKey: self.cacheKey!)
        completion()
    }
    
    internal func clearFactoryWithUIImage(completion: @escaping ()->Void) {
        self.animationUIImageFrames = []
        self.imageSource = nil
        self.totalFrameCount = 0
        self.isResizing = false
        completion()
    }
    
    internal func setupGIFImageFramesWithGIFOFrame(cacheKey: String,
                                                   level: GIFFrameReduceLevel = .highLevel,
                                                   animationOnReady: @escaping () -> Void) {
        self.cacheKey = cacheKey
        guard let imageSource = self.imageSource else {
            return
        }
        
        let frames = convertCGImageSourceToGIFOFrameArray(source: imageSource)
        let levelFrames = getLevelFrameWithGIFOFrame(level: level, frames: frames)
        
        self.animationGIFOFrames = levelFrames
        
        GIFOImageCacheManager.shared.addGIFImages(images: levelFrames,
                                                  forKey: cacheKey)
        animationOnReady()
    }
    
    internal func getGIFImageWithUIImage(cacheKey: String,
                                         level: GIFFrameReduceLevel = .highLevel,
                                         animationOnReady: @escaping (UIImage) -> Void) {
        self.cacheKey = cacheKey
        guard let imageSource = self.imageSource else {
            return
        }
        
        let frames = convertCGImageSourceToUIImageArray(imageSource)
        let levelFrames = getLevelFrameWithUIImage(level: level, frames: frames)
        
        guard let animatedImage = UIImage.animatedImage(with: levelFrames, duration: self.animationTotalDuration) else { return }
        
        GIFOImageCacheManager.shared.addGIFUIImage(image: animatedImage,
                                                   forKey: cacheKey)
        
        animationOnReady(animatedImage)
    }
    
    internal func setupCachedImageFramesWithGIFOFrame(cacheKey: String,
                                                      level: GIFFrameReduceLevel = .highLevel,
                                                      animationOnReady: @escaping () -> Void) {
        guard let cgImages = GIFOImageCacheManager.shared.getGIFImages(forKey: cacheKey) else {
            print("get cachedImages - failure")
            return
        }
        animationGIFOFrames = cgImages
        totalFrameCount = cgImages.count
        animationOnReady()
    }
    
    private func getLevelFrameWithGIFOFrame(level: GIFFrameReduceLevel,
                                           frames: [GIFOFrame]) -> [GIFOFrame] {
        switch level {
        case .highLevel:
            return frames
        case .middleLevel:
            return reduceFramesWithGIFOFrame(GIFFrames: frames, level: 2)
        case .lowLevel:
            return reduceFramesWithGIFOFrame(GIFFrames: frames, level: 3)
        }
    }
    
    private func getLevelFrameWithUIImage(level: GIFFrameReduceLevel,
                                          frames: [UIImage]) -> [UIImage] {
        switch level {
        case .highLevel:
            return frames
        case .middleLevel:
            return reduceFramesWithUIImage(GIFFrames: frames, level: 2)
        case .lowLevel:
            return reduceFramesWithUIImage(GIFFrames: frames, level: 3)
        }
    }
    
    private func convertCGImageSourceToGIFOFrameArray(source: CGImageSource) -> [GIFOFrame] {
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
    
    private func convertCGImageSourceToUIImageArray(_ source: CGImageSource) -> [UIImage] {
        let frameCount = CGImageSourceGetCount(source)
        var frameProperties: [UIImage] = []
        
        for i in 0..<frameCount {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                return []
            }
            
            guard let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any] else {
                return []
            }
            
            if isResizing {
                guard let resizeImage = resize(source,i,image) else { return [] }
                frameProperties.append(UIImage(cgImage: resizeImage))
            } else {
                frameProperties.append(UIImage(cgImage: image))
            }
            
            frameDurations?.append(applyMinimumDelayTime(properties))
            animationTotalDuration += applyMinimumDelayTime(properties)
        }
        
        return frameProperties
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
    
    private func reduceFramesWithGIFOFrame(GIFFrames: [GIFOFrame],
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
    
    private func reduceFramesWithUIImage(GIFFrames: [UIImage],
                                         level: Int) -> [UIImage] {
        let frameCount = GIFFrames.count
        let reducedFrameCount = max(frameCount/level, 1)
        
        var reducedFrames: [UIImage] = []
        var reducedFrameDurations: [Double] = []
        
        for i in 0..<reducedFrameCount {
            
            let originalFrameIndex = i * level
            
            guard let frameDuration = self.frameDurations?[originalFrameIndex] else {
                return []
            }

            reducedFrameDurations.append(frameDuration * Double(level))
            reducedFrames.append(GIFFrames[originalFrameIndex])
        }
        
        totalFrameCount = reducedFrameCount
        frameDurations = reducedFrameDurations
        
        return reducedFrames
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
