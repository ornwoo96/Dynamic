//
//  GIFFrame.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

internal struct GIFOFrame {
    static let empty: Self = .init(image: UIImage().cgImage!,
                                   duration: 0.0)
    
    var image: UIImage
    var duration: Double
    
    init(image: CGImage,
         duration: Double) {
        self.image = UIImage(cgImage: image)
        self.duration = duration
    }
    
    init(image: UIImage,
         duration: Double) {
        self.image = image
        self.duration = duration
    }
}

