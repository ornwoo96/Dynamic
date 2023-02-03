//
//  UIView+Ratio.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

extension UIView {
    func xValueRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.maxX*(value/390)
    }
    
    func yValueRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.maxY*(value/844)
    }
    
    static var xMax: CGFloat {
        return UIScreen.main.bounds.maxX
    }
    
    func calculateXMax() -> CGFloat {
        return UIScreen.main.bounds.maxX
    }
}
