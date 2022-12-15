//
//  CustomNavigationBar.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit

protocol CustomNavigationBarDelegate {
    
}

final class CustomNavigationBar: UINavigationBar {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
