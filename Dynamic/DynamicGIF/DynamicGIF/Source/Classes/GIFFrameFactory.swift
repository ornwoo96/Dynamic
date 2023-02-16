//
//  GIFFrameFactory.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/06.
//

import UIKit

internal enum GIFError: Error {
    case noImages
}

public enum GIFFrameReduceLevel {
    case highLevel
    case middleLevel
    case lowLevel
}

internal class GIFFrameFactory {
    var animationFrames: [GIFFrame] = []
    var imageSource: CGImageSource
    var imageSize: CGSize
    var contentMode: UIView.ContentMode
    var totalFrameCount: Int?
    var isResizing: Bool = false
    
    init(data: Data,
         size: CGSize,
         contentMode: UIView.ContentMode = .scaleAspectFill) {
        let options = [String(kCGImageSourceShouldCache): kCFBooleanFalse] as CFDictionary
        self.imageSource = CGImageSourceCreateWithData(data as CFData, options) ?? CGImageSourceCreateIncremental(options)
        self.imageSize = size
        self.contentMode = contentMode
        self.animationFrames = convertCGImageSourceToGIFFrameArray(source: self.imageSource)
    }
    
    public func setupGIFImageFrames(level: GIFFrameReduceLevel = .highLevel) -> [GIFFrame] {
        if isResizing {
            let resizedFrames = resize(size: self.imageSize)
            let convertFramesArray = convertCGImageSourceToGIFFrameArray(source: resizedFrames)
            return getLevelFrame(level: level, frames: convertFramesArray)
        } else {
            return getLevelFrame(level: level, frames: self.animationFrames)
        }
    }
    
    private func getLevelFrame(level: GIFFrameReduceLevel,
                               frames: [GIFFrame]) -> [GIFFrame] {
        switch level {
        case .highLevel:
            return self.animationFrames
        case .middleLevel:
            return reduceFrames(GIFFrames: frames, level: 2)
        case .lowLevel:
            return reduceFrames(GIFFrames: frames, level: 3)
        }
    }
    
    private func convertCGImageSourceToGIFFrameArray(source: CGImageSource) -> [GIFFrame] {
        let frameCount = CGImageSourceGetCount(source)
        var frameProperties: [GIFFrame] = []
        
        for i in 0..<frameCount {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                continue
            }
            
            let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any]
            
            var duration = 0.1
            
            if let gifProperties = properties?[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                duration = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
            }
            
            frameProperties.append(GIFFrame(image: image, duration: duration))
        }
        
        return frameProperties
    }
    
    private func reduceFrames(GIFFrames: [GIFFrame],
                              level: Int) -> [GIFFrame] {
        let frameCount = GIFFrames.count
        let reducedFrameCount = max(frameCount/level, 1)
        
        var reducedFrameProperties: [GIFFrame] = []
        
        for i in 0..<reducedFrameCount {
            var gifFrame = GIFFrame.empty
            let originalFrameIndex = i * level
            
            gifFrame.image = GIFFrames[originalFrameIndex].image
            gifFrame.duration = GIFFrames[originalFrameIndex].duration * Double(level)
            
            reducedFrameProperties.append(gifFrame)
        }
        
        totalFrameCount = reducedFrameProperties.count
        
        return reducedFrameProperties
    }
    
    private func resize(size: CGSize) -> CGImageSource {
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: max(Int(size.width), Int(size.height))
        ]
        
        let resizedImageSource = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        
        return resizedImageSource as! CGImageSource
    }
}
