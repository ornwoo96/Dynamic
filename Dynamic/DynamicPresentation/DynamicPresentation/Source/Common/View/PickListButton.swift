//
//  PickListButton.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/15.
//

import UIKit

internal class PickListButton: UIView {
    internal var backgroundView = UIButton()
    private(set) lazy var pickListLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: xValueRatio(17), weight: .heavy)
        return label
    }()
    private var gradient = CAGradientLayer()
    private var gradientFromValue: [CGColor] = [UIColor.systemRed.cgColor,
                                                UIColor.systemPink.cgColor,
                                                UIColor.systemPurple.cgColor,
                                                UIColor.systemBlue.cgColor]
    private(set) lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: xValueRatio(20), weight: .heavy)
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
        setupBackgroundView()
        setupBackgroundViewGradient()
        setupTitleLabel()
        setupNumberLabel()
    }
    
    private func setupTitleLabel() {
        backgroundView.addSubview(pickListLabel)
        pickListLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickListLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pickListLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
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
    
    private func setupNumberLabel() {
        backgroundView.addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        numberLabel.isHidden = true
    }
    
    private func setupBackgroundViewGradient() {
        gradient.colors = [UIColor.systemRed.cgColor,
                           UIColor.systemPink.cgColor,
                           UIColor.systemPurple.cgColor,
                           UIColor.systemBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: xValueRatio(100),
                                                            height: xValueRatio(40)))
        
        backgroundView.layer.addSublayer(gradient)
    }
    
    internal func setupLabels(_ action: MainNavigationBar.FavoritesAction) {
        switch action {
        case .none:
            numberLabel.isHidden = true
            pickListLabel.isHidden = false
        case .number:
            numberLabel.isHidden = false
            pickListLabel.isHidden = true
        }
    }
}
