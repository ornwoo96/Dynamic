//
//  GIFOImageCacheItem.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/03/07.
//

import UIKit

internal class GIFOImageCacheItem {
    let images: [GIFOFrame]

    init(images: [GIFOFrame]) {
        self.images = images
    }
}
