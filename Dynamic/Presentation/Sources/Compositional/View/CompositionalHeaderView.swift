//
//  CompositionalHeaderView.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/23.
//

import UIKit

class CompositionalHeaderView: UICollectionReusableView {
    static let identifier = "CompositionalHeaderView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
