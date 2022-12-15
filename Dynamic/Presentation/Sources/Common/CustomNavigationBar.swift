//
//  CustomNavigationBar.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit

protocol CustomNavigationBarDelegate {
    
}

final class CustomNavigationBar: UINavigationBar {
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.1
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "DYNAMIC"
        label.font = UIFont.systemFont(ofSize: xValueRatio(30), weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    private var pickListButton = PickListButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupBackgroundView()
        setupTitleLabel()
        setupPickListButton()
    }
    
    private func setupBackgroundView() {
        self.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupTitleLabel() {
        backgroundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: xValueRatio(10)),
            titleLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -xValueRatio(5))
        ])
    }
    
    private func setupPickListButton() {
        backgroundView.addSubview(pickListButton)
        pickListButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickListButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            pickListButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -xValueRatio(10)),
            pickListButton.widthAnchor.constraint(equalToConstant: xValueRatio(110)),
            pickListButton.heightAnchor.constraint(equalToConstant: xValueRatio(40))
        ])
    }
}
