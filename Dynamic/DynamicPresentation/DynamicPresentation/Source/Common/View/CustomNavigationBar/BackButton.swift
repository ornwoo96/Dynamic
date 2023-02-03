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
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        } set {
            if newValue {
                backgroundColor = .buttonHighlightColor
            } else {
                backgroundColor = .clear
            }
            super.isHighlighted = newValue
        }
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
            backImageView.topAnchor.constraint(equalTo: topAnchor, constant: xValueRatio(10)),
            backImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xValueRatio(10)),
            backImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -xValueRatio(10)),
            backImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -xValueRatio(10))
        ])
    }
}
