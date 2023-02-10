//
//  GIFImage.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit
import ImageIO


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
}
