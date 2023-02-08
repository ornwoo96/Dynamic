//
//  CGImageSource.swift
//  DynamicGIF
//
//  Created by 김동우 on 2023/02/06.
//

import ImageIO
import UIKit

typealias GIFProperties = [String: Double]

extension CGImageSource {
    func properties(at index: Int) -> GIFProperties? {
        guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(self, index, nil) as? [String: AnyObject] else {
            return nil
        }
        return imageProperties[String(kCGImagePropertyGIFDictionary)] as? GIFProperties
    }
    
    
    
}


