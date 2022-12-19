//
//  PickListButton.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit

final class PickListButton: UIButton {
    private lazy var pickListLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: xValueRatio(17), weight: .heavy)
        return label
    }()
    
    private lazy var heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.tintColor = .systemRed
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
        setupTitleLabel()
        setupHeartImageView()
    }
    
    private func setupTitleLabel() {
        self.addSubview(pickListLabel)
        pickListLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickListLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            pickListLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func setupHeartImageView() {
        self.addSubview(heartImageView)
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartImageView.leadingAnchor.constraint(equalTo: pickListLabel.trailingAnchor, constant: xValueRatio(5)),
            heartImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: yValueRatio(1)),
            heartImageView.heightAnchor.constraint(equalToConstant: xValueRatio(25)),
            heartImageView.widthAnchor.constraint(equalToConstant: xValueRatio(25))
        ])
    }
}
