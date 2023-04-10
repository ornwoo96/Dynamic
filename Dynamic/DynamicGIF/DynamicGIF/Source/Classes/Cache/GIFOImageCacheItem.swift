//
//  GIfImageCacheItem.swift
//  BMOGIF
//
//  Created by 김동우 on 2023/02/28.
//

import UIKit

internal class GIFOImageCacheItem {
    let frames: [GIFOFrame]

    init(frames: [GIFOFrame]) {
        self.frames = frames
    }
}
