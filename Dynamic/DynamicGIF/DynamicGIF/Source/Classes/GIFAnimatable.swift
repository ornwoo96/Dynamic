//
//  GIFAnimatable.swift
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

public protocol GIFAnimatable: AnyObject {
    
}

extension GIFAnimatable {
    public func animate(withGIFData: Data) {
        
    }
}
