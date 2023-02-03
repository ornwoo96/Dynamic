//
//  UIView + Shadow.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/31.
//

import UIKit

extension UIView {
    static func labelShadow(label: UILabel) {
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 2
    }
}
