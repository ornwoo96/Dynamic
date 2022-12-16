//
//  CGFloat + Resize.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/16.
//

import UIKit

extension CGFloat {
    static func ImageResizeHeight(_ width: CGFloat,
                                  _ height: CGFloat,
                                  _ maxX: CGFloat,
                                  _ maxY: CGFloat) -> CGFloat {
        if width >= maxX {
            return (maxX * height)/width
        } else {
            return height
        }
    }
    
    static func ImageResizeWidth(_ width: CGFloat,
                                 _ height: CGFloat,
                                 _ maxY: CGFloat,
                                 _ maxX: CGFloat) -> CGFloat {
        if width >= maxX {
            return (maxY * width)/height
        } else {
            return width
        }
    }
}
