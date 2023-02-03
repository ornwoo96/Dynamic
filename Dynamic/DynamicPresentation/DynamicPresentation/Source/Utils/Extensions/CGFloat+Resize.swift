//
//  CGFloat + Resize.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2023/01/15.
//

import UIKit

extension CGFloat {
    static func resizeHeight(height: CGFloat, width: CGFloat) -> CGFloat {
        let convertHeight = height
        let convertWidth = width
        let resizeWidth = UIScreen.main.bounds.maxX
        
        if convertWidth > resizeWidth {
            let result = (resizeWidth*convertHeight) / convertWidth
            return result
        } else {
            return convertHeight
        }
    }
    
    static func resizeWidth(height: CGFloat, width: CGFloat) -> CGFloat {
        let convertHeight = height
        let convertWidth = width
        let resizeWidth = UIScreen.main.bounds.maxX

        if convertWidth > resizeWidth {
            let result = (CGFloat.resizeHeight(height: height,
                                               width: width)*convertWidth) / convertHeight
            return result
        } else {
            return convertWidth
        }
    }
}
