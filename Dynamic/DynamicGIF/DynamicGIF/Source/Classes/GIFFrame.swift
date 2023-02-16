//
//  GIFFrame.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

struct GIFFrame {
    static let empty: Self = .init(image: UIImage().cgImage,
                                   duration: 0.0)
    
    var image: CGImage?
    var duration: Double
}
