//
//  GIFFrameFactory.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/06.
//

import UIKit

internal class GIFFrameFactory {
    var animationFrames: [GIFFrame] = []
    var imageSource: CGImageSource
    var imageSize: CGSize
    var contentMode: UIView.ContentMode
    var loopCount: Int
    
    init(data: Data,
         size: CGSize,
         contentMode: UIView.ContentMode = .scaleAspectFill,
         loopCount: Int = 0) {
        let options = [String(kCGImageSourceShouldCache): kCFBooleanFalse] as CFDictionary
        self.imageSource = CGImageSourceCreateWithData(data as CFData, options) ?? CGImageSourceCreateIncremental(options)
        self.imageSize = size
        self.contentMode = contentMode
        self.loopCount = loopCount
    }
}
