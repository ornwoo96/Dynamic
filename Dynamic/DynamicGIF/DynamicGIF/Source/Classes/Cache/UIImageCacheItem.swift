//
//  UIImageCacheItem.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/04/02.
//

import UIKit

internal class UIImageCacheItem {
    let frame: UIImage
    let sizeInBytes: Int?
    
    init(frame: UIImage) {
        self.frame = frame
        self.sizeInBytes = UIImageCacheItem.convertFramesToData(frame).count
    }
    
    static func convertFramesToData(_ frame: UIImage) -> Data {
        guard let data = frame.jpegData(compressionQuality: 1) else {
            print("")
            return Data()
        }
        return data
    }
}
