//
//  GIFImage.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit
import ImageIO

internal enum GIFError: Error {
    case noImages
}

public enum GIFQuality: CGFloat {
    case defaultQuality = 1
}

class GIFImage {
    var frameFactory: GIFFrameFactory?
    var size: CGSize?
    
    init(size: CGSize) {
        self.size = size
    }
    
    public func animate(withGIFData: Data) {
        
    }
    
    public func animate(withGIFUrl: String) {
        
    }
    
    public func animate(GIFName: String) {
        
    }
    
    
    
    // Step 1: Get original GIF frame information
    func getFrameProperties(from gifURL: URL) -> [(duration: Double, image: CGImage?)] {
        guard let source = CGImageSourceCreateWithURL(gifURL as CFURL, nil) else {
            return []
        }
        
        let frameCount = CGImageSourceGetCount(source)
        var frameProperties: [(duration: Double, image: CGImage?)] = []
        
        for i in 0..<frameCount {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                continue
            }
            
            let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any]
            
            var duration = 0.1
            if let gifProperties = properties?[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                duration = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0.1
            }
            
            frameProperties.append((duration, image))
        }
        
        return frameProperties
    }
    
    // Step 2: Create new frame information based on original frame information
    func reduceFrames(for frameProperties: [(duration: Double, image: CGImage?)],
                      to scale: Int) -> [(duration: Double, image: CGImage?)] {
        let frameCount = frameProperties.count
        let reducedFrameCount = max(frameCount / scale, 1)
        
        var reducedFrameProperties: [(duration: Double, image: CGImage?)] = []
        for i in 0..<reducedFrameCount {
            let originalFrameIndex = i * scale
            reducedFrameProperties.append(frameProperties[originalFrameIndex])
        }
        
        return reducedFrameProperties
    }
    
    // Step 3: Create new GIF image based on new frame information
    func createReducedGIF(from frameProperties: [(duration: Double, image: CGImage?)],
                          to URL: URL) {
        let destination = CGImageDestinationCreateWithURL(URL as CFURL,
                                                          kUTTypeGIF,
                                                          frameProperties.count,
                                                          nil)
        
        let framePropertiesDictionary: [String: Any] = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: NSNumber(value: 0.1)]]
        
        for (duration, image) in frameProperties {
            if let image = image {
                CGImageDestinationAddImage(destination ?? nil, image, framePropertiesDictionary as CFDictionary)
            }
        }
        
        CGImageDestinationFinalize(destination ?? nil)
    }
    
    // Step 4: Display reduced GIF image with desired frame count
    let originalGIFURL = URL(fileURLWithPath: "path/to/original.gif")
    let reducedGIFURL = URL(fileURLWithPath: "path/to/reduced.gif")
    
    let originalFrameProperties = self.getFrameProperties(from: self.originalGIFURL)
    let reducedFrameProperties = reduceFrames(for: originalFrameProperties, to: 4)
    
    createReducedGIF(from: reducedFrameProperties, to: reduced)
    
}
