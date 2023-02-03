//
//  UIView+Radius.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

extension UIView {
    func roundCorners(cornerRadius: CGFloat,
                      maskedCorners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
    func viewRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}
