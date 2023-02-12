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

public enum GIFFrameReduceLevel: Int {
    case highLevel = 1
    case middleLevel = 2
    case lowLevel = 3
}

internal class GIFFrameFactory {
    var animationFrames: [GIFFrame] = []
    var imageSource: CGImageSource
    var imageSize: CGSize
    var contentMode: UIView.ContentMode
    var loopCount: Int
    var totalFrameCount: Int
    
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
    
    func setupGIFFromData(level: GIFMemoryReduce = .resizing(.highLevel)) -> [GIFFrame] {
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
        let frameCount = GIFFrames.count
        guard let level = level as? Int else {
            return []
        }
        let reducedFrameCount = max(frameCount/level, 1)
        
        var reducedFrameProperties: [GIFFrame] = []
        
        for i in 0..<reducedFrameCount {
            let originalFrameIndex = i * level
            reducedFrameProperties.append(GIFFrames[originalFrameIndex])
        }
        
        return reducedFrameProperties
    }
    
    // Step 3: Create new GIF image based on new frame information
    private func createReducedGIF(from frameProperties: [(duration: Double, image: CGImage?)],
                                  to URL: URL) {
        let destination = CGImageDestinationCreateWithURL(URL as CFURL,
                                                          kUTTypeGIF,
                                                          frameProperties.count,
                                                          nil)
        
        let framePropertiesDictionary: [String: Any] = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: NSNumber(value: 0.1)]]
        
        for (duration, image) in frameProperties {
            if let image = image {
                CGImageDestinationAddImage(destination ?? nil,
                                           image,
                                           framePropertiesDictionary as CFDictionary)
            }
        }
        
        CGImageDestinationFinalize(destination)
    }
}
