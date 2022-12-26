//
//  FavoritesNavigationBar.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/26.
//

import UIKit

protocol BackButtonProtocol {
    func backButtonDidTap()
}

class FavoritesNavigationBar: UIView {
    internal var delegate: BackButtonProtocol?
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "FAVORITES"
        label.font = UIFont.systemFont(ofSize: xValueRatio(30), weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    private lazy var backButton: BackButton = {
        let button = BackButton()
        button.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        return button
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
        setupBackButton()
    }
    
    private func setupTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -xValueRatio(5))
        ])
    }
    
    private func setupBackButton() {
        self.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: xValueRatio(10)),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            backButton.heightAnchor.constraint(equalToConstant: yValueRatio(20)),
            backButton.widthAnchor.constraint(equalToConstant: xValueRatio(20))
        ])
    }
    
    @objc private func backButtonDidTap(_ sender: UIButton) {
        delegate?.backButtonDidTap()
    }
}
