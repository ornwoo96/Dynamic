//
//  UIImageCacheItem.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/04/02.
//

import UIKit

internal class UIImageCacheItem {
    internal let frames: [UIImage]
    
    init(frames: [UIImage]) {
        self.frames = frames
    }
}
