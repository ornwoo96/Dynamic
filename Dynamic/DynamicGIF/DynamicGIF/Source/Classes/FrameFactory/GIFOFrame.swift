//
//  GIFFrame.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/03.
//

import UIKit

/// Represents a single frame in a GIF.
internal struct GIFOFrame {
    
    /// Empty GIFOFrame instance for convenience
    static let empty: Self = .init(image: UIImage().cgImage!,
                                   duration: 0.0)
    
    /// The image of the frame
    var image: UIImage
    
    /// The duration of the frame in seconds
    var duration: Double
    
    /// Initializes a GIFOFrame instance with a CGImage
    init(image: CGImage,
         duration: Double) {
        self.image = UIImage(cgImage: image)
        self.duration = duration
    }
    
    /// Initializes a GIFOFrame instance with a UIImage
    init(image: UIImage,
         duration: Double) {
        self.image = image
        self.duration = duration
    }
}
