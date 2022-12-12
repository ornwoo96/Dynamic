//
//  TabBarItem.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/12.
//

import UIKit

final class TabBarItem: UIButton {
    private(set) lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private(set) lazy var DotView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupItemImageView()
        setupDotView()
    }
    
    private func setupItemImageView() {
        addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: self.topAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemImageView.heightAnchor.constraint(equalToConstant: )
        ])
    }
    
    private func setupDotView() {
        addSubview(DotView)
        DotView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
