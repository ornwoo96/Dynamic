//
//  CategoryView.swift
//  DynamicPresentation
//
//  Created by 김동우 on 2022/12/23.
//

import UIKit

internal protocol CategoryViewProtocol {
    func buttonDidTap(_ tag: Int)
}

internal class CategoryView: UIView {
    internal var delegate: CategoryViewProtocol?
    internal var backgroundView = UIView()
    private var scrollView = UIScrollView()
    private var stackView = UIStackView()
    internal var selectedView = UIView()
    private var selectedViewLeadingConstraint: NSLayoutConstraint?
    private var selectedViewWidthConstraint: NSLayoutConstraint?
    private var selectedViewGradientLayer = CAGradientLayer()
    private var seriesColorFromValue: [CGColor] = UIColor.gradientSeries1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupView()
        setupScrollView()
        setupSelectedView()
        setupStackView()
        setupGradient()
    }
    
    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.maxX,
                                                            height: yValueRatio(45)))
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.locations = [0.7, 0.95]
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.homeAlphaBlackColor2.cgColor
        ]
        self.layer.addSublayer(gradient)
    }
    
    private func setupView() {
        self.setGradientWithThreeColor(.categoryBackgroundColor1,
                                       .categoryBackgroundColor2,
                                       .categoryBackgroundColor3,
                                       CGSize(width: self.calculateXMax(),
                                              height: yValueRatio(45)))
        self.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupStackView() {
        for i in createCategoryItems() {
            stackView.addArrangedSubview(i)
        }
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = xValueRatio(20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: .zero, left: xValueRatio(20), bottom: .zero, right: .zero)
        scrollView.addSubview(stackView)
        scrollView.contentSize = CGSize(width: xValueRatio(690), height: yValueRatio(60))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        backgroundView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupSelectedView() {
        selectedView.backgroundColor = .black
        selectedView.viewRadius(cornerRadius: xValueRatio(22.5))
        scrollView.addSubview(selectedView)
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedViewLeadingConstraint = selectedView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: xValueRatio(5))
        selectedViewWidthConstraint = selectedView.widthAnchor.constraint(equalToConstant: xValueRatio(92))
        NSLayoutConstraint.activate([
            selectedView.topAnchor.constraint(equalTo: self.topAnchor),
            selectedView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        selectedViewLeadingConstraint?.isActive = true
        selectedViewWidthConstraint?.isActive = true
        selectedViewGradientLayer.colors = UIColor.gradientSeries1
        selectedViewGradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        selectedViewGradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        selectedViewGradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: xValueRatio(210),
                                                                             height: xValueRatio(45)))
        
        selectedView.layer.addSublayer(selectedViewGradientLayer)
    }
    
    private func createCategoryItems() -> [UIButton] {
        var buttons: [UIButton] = []
        let categorys: [String] = ["Coding", "Memes", "Cats" , "Dogs", "Christmas", "Oops", "Reactions", "Emoji"]
        var count = 0
        for category in categorys {
            buttons.append(createCategoryItem(category, count))
            count += 1
        }
        return buttons
    }
    
    private func createCategoryItem(_ title: String,
                                    _ count: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: xValueRatio(18), weight: .heavy)
        button.tintColor = .clear
        button.tag = count
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        delegate?.buttonDidTap(sender.tag)
        self.branchButtonTag(sender.tag)
    }
    
    internal func branchButtonTag(_ tag: Int) {
        switch tag {
        case 0:
            self.buttonTapAnimations(6, 90, 0, 0)
        case 1:
            self.buttonTapAnimations(89, 90, 1, 0)
        case 2:
            self.buttonTapAnimations(175.5, 65, 2, 12.5)
        case 3:
            self.buttonTapAnimations(237, 70, 3, 77.5)
        case 4:
            self.buttonTapAnimations(302, 120, 4, 168)
        case 5:
            self.buttonTapAnimations(416, 72, 5, 257.5)
        case 6:
            self.buttonTapAnimations(482.5, 112.5, 6, 300)
        case 7:
            self.buttonTapAnimations(591, 77.5, 7, 300)
        default: break
        }
    }
    
    private func buttonTapAnimations(_ leading: CGFloat,
                                     _ width: CGFloat,
                                     _ number: Int,
                                     _ xPointValue: CGFloat) {
        animateButton(xValueRatio(leading), xValueRatio(width))
        animateGradient(UIColor.branchGradient(number: number))
        seriesColorFromValue = UIColor.branchGradient(number: number)
        scrollToCenter(xValueRatio(xPointValue))
    }
    
    private func scrollToCenter(_ xValue: CGFloat) {
        scrollView.setContentOffset(CGPoint(x: xValue, y: 0), animated: true)
    }
    
    private func animateButton(_ leading: CGFloat, _ width: CGFloat) {
        selectedViewLeadingConstraint?.constant = leading
        selectedViewWidthConstraint?.constant = width
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    private func animateGradient(_ colors: [CGColor]) {
        let animation2 = CABasicAnimation(keyPath: "colors")
        animation2.duration = 1
        animation2.fromValue = seriesColorFromValue
        animation2.toValue = colors
        animation2.isRemovedOnCompletion = false
        animation2.fillMode = CAMediaTimingFillMode.forwards
        selectedViewGradientLayer.add(animation2, forKey: "colors")
    }
    
    internal func setupBackGroundViewWhenHideBar() {
        self.backgroundView.backgroundColor = .black

    }
    
    internal func setupBackGroundViewWhenShowBar() {
        self.backgroundView.backgroundColor = .clear
    }
}
