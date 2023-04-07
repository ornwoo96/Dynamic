//
//  GIfImageCacheItem.swift
//  BMOGIF
//
//  Created by 김동우 on 2023/02/28.
//

import UIKit

internal class GIFOImageCacheItem {
    let frames: [GIFOFrame]
    let sizeInBytes: Int?

    init(frames: [GIFOFrame]) {
        self.frames = frames
        self.sizeInBytes = frames.reduce(0) {
            $0 + GIFOImageCacheItem.convertFramesToData($1.image).count
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
