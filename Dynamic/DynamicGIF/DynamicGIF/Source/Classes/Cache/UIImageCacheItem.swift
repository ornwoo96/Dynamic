//
//  UIImageCacheItem.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/04/02.
//

import UIKit

internal class UIImageCacheItem {
    let frames: [UIImage]
    let sizeInBytes: Int?
    
    init(frames: [UIImage]) {
        self.frames = frames
        self.sizeInBytes = frames.reduce(0) {
            $0 + UIImageCacheItem.convertFramesToData($1).count
        }
    }
    
    static func convertFramesToData(_ frame: UIImage) -> Data {
        guard let data = frame.jpegData(compressionQuality: 1) else {
            print("")
            return Data()
        }
        return data
    }
}
