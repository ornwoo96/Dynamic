//
//  GIfImageCacheItem.swift
//  BMOGIF
//
//  Created by 김동우 on 2023/02/28.
//

import UIKit

internal class GIFOImageCacheItem {
    let layers: [GIFOFrame]

    init(layers: [GIFOFrame]) {
        self.layers = layers
    }
}
