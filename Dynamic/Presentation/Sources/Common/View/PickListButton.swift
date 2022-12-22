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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        self.addSubview(pickListLabel)
        pickListLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickListLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pickListLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
}
