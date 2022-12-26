//
//  BackButton.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/26.
//

import UIKit

class BackButton: UIButton {
    private lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.backward")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        return imageView
    }()
    
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
        self.addSubview(backImageView)
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backImageView.topAnchor.constraint(equalTo: topAnchor),
            backImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
