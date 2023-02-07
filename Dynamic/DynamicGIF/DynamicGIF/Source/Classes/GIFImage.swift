//
//  GIFImage.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

internal enum GIFError: Error {
    case noImages
}

public enum GIFQuality: CGFloat {
    case defaultQuality = 1
}

class GIFImage {
    var frameFactory: GIFFrameFactory?
    
    public func animate(withGIFData: Data) {
        
    }
    
    public func animate(withGIFUrl: String) {
        
    }
    
    public func animate(GIFName: String) {
        
    }
}
