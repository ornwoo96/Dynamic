//
//  PageLoadingView.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/27.
//

import UIKit

class PageLoadingView: UIView {
    private var square1 = UIView()
    private var square2 = UIView()
    private var square3 = UIView()
    private var square4 = UIView()
    private var square5 = UIView()
    private var square6 = UIView()
    private var square7 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
    }
    
}

extension PageLoadingView {
    private func animate
}
