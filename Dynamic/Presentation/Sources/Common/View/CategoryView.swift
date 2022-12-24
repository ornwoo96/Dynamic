//
//  CategoryView.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/23.
//

import UIKit

class CategoryView: UICollectionReusableView {
    static let identifier: String = "CategoryView"
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
    }
    
    
}
