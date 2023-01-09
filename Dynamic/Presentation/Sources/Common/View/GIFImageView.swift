//
//  UIImageView+GIF.swift
//  DynamicPresentationTests
//
//  Created by 김동우 on 2023/01/05.
//

import UIKit

public class GIFImageView: UIView {
    
    private let gifImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupImageView()
    }
    
    private func setupImageView() {
        self.addSubview(gifImageView)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: self.topAnchor),
            gifImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    public func clearGIFImageView() {
        
    }
    
    public func configureGIFImageView() {
        
    }
    
}
