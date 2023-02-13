//
//  GIFFrameFactory.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/06.
//

import UIKit

typealias GIFProperties = [String: Double]

internal enum GIFError: Error {
    case noImages
}

public enum GIFMemoryReduce {
    case frameDown(GIFFrameReduceLevel)
    case downSampling(GIFFrameReduceLevel)
    case resizing(GIFFrameReduceLevel)
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
    var loopCount: Int
    var totalFrameCount: Int?
    
    init(data: Data,
         size: CGSize,
         contentMode: UIView.ContentMode = .scaleAspectFill,
         loopCount: Int = 0) {
        let options = [String(kCGImageSourceShouldCache): kCFBooleanFalse] as CFDictionary
        self.imageSource = CGImageSourceCreateWithData(data as CFData, options) ?? CGImageSourceCreateIncremental(options)
        self.imageSize = size
        self.contentMode = contentMode
        self.loopCount = loopCount
        setupGIFFrames()
    }
    
    func setupFrames() {
        
    }
    
    private func setupGIFFromData(level: GIFMemoryReduce = .frameDown(.highLevel)) -> [GIFFrame] {
        switch level {
        case .frameDown(let gIFFrameReduceLevel):
            let result = reduceFrames(GIFFrames: self.animationFrames, level: gIFFrameReduceLevel)
            return result
        case .downSampling(let gIFFrameReduceLevel):
            
            return []
        case .resizing(let gIFFrameReduceLevel):
            
            return []
        }
    }
    
    private func setupGIFFrames() {
        let frameCount = CGImageSourceGetCount(self.imageSource)
        var frameProperties: [GIFFrame] = []
        
        for i in 0..<frameCount {
            guard let image = CGImageSourceCreateImageAtIndex(self.imageSource, i, nil) else {
                continue
            }
            
            let properties = CGImageSourceCopyPropertiesAtIndex(self.imageSource, i, nil) as? [String: Any]
            
            var duration = 0.1
            
            if let gifProperties = properties?[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                duration = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
            }
            
            frameProperties.append(GIFFrame(image: image, duration: duration))
        }
        
        animationFrames = frameProperties
    }
    
    private func reduceFrames(GIFFrames: [GIFFrame],
                              level: GIFFrameReduceLevel) -> [GIFFrame] {
        let level = convertType(level: level)
        
        if level == 1 {
            return GIFFrames
        }
        
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
    
    private func downSamplingImages(GIFFrames: [GIFFrame]) -> [GIFFrame] {
        for i in 0..<GIFFrames.count {
            // Get the current frame
            let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil)!

            // Down-sample the image
            let downSampledImage = cgImage.downsample(factor: 0.5)
            
            // Add the down-sampled image to the array
            downSampledFrames.append(downSampledImage)
        }
        
        return []
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
    
    private func convertType(level: GIFFrameReduceLevel) -> Int {
        switch level {
        case .highLevel:
            return 1
        case .middleLevel:
            return 2
        case .lowLevel:
            return 3
        }
    }
}
