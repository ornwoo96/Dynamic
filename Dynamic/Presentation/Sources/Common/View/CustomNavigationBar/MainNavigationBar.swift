//
//  MainNavigationBar.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/26.
//

import UIKit

protocol CustomNavigationBarDelegate {
    func favoritesButtonTapped()
}

class MainNavigationBar: UIView {
    var delegate: CustomNavigationBarDelegate?
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
    
    private lazy var pickListButton: PickListButton = {
        let button = PickListButton()
        button.backgroundView.addTarget(self, action: #selector(favoritesButtonTapped(_:)), for: .touchUpInside)
        button.viewRadius(cornerRadius: xValueRatio(14))
        return button
    }()
    
    private var pickListButtonWidthConstraint: NSLayoutConstraint?
    private var pickListButtonHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            pickListButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -xValueRatio(5)),
            pickListButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -xValueRatio(10))
        ])
        pickListButtonWidthConstraint = pickListButton.widthAnchor.constraint(equalToConstant: xValueRatio(100))
        pickListButtonHeightConstraint = pickListButton.heightAnchor.constraint(equalToConstant: xValueRatio(30))
        pickListButtonHeightConstraint?.isActive = true
        pickListButtonWidthConstraint?.isActive = true
    }
    
    
    
    @objc private func favoritesButtonTapped(_ sender: UIButton) {
        delegate?.favoritesButtonTapped()
    }
}

extension MainNavigationBar {
    public enum FavoritesAction {
        case none
        case number
    }
    
    public func checkNumber(_ count: Int) {
        if count == 0 {
            self.animateNonePickListButton()
        } else {
            self.animateNumberPickListButton(count)
        }
    }

    
    private func animateNonePickListButton() {
        pickListButtonWidthConstraint?.constant = xValueRatio(100)
        pickListButtonHeightConstraint?.constant = xValueRatio(30)
        pickListButton.setupLabels(.none)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5) {
            self.pickListButton.viewRadius(cornerRadius: self.xValueRatio(14))
            self.layoutIfNeeded()
        }
    }
    
    private func animateNumberPickListButton(_ count: Int) {
        pickListButton.setupLabels(.number)
        pickListButton.numberLabel.text = "\(count)"
        pickListButtonHeightConstraint?.constant = xValueRatio(40)
        pickListButtonWidthConstraint?.constant = xValueRatio(40)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5) {
            self.pickListButton.viewRadius(cornerRadius: self.xValueRatio(20))
            self.layoutIfNeeded()
        }
    }
}


